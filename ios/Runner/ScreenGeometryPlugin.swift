import Flutter
import UIKit

/// Sends Dart what Flutter 3.47 does not report on iOS (DEC-3): the screen the app's scene
/// is on, the hinge, the fold and the other reserved regions, and the edge where the system
/// puts vertical bars. Flutter's `PlatformDispatcher.displays` is read once from
/// `UIScreen.main`, which on iPhone Duo stays the outer display, and its
/// `MediaQuery.displayFeatures` is always empty on iOS.
///
/// Each event is a map: `screen` [width, height] in points, `hinge` (0 unknown or no hinge,
/// 1 closed, 2 partially open, 3 fully open), `hingeAngle` in degrees, `divisions` and
/// `occlusions` as [left, top, width, height, active] in the Flutter view's points, and
/// `barEdge` "left", "right" or absent. The sides are physical: Apple keeps the vertical bar
/// on the same side of the hardware in right-to-left languages.
final class ScreenGeometryPlugin: NSObject, FlutterStreamHandler {
  static func register(with registrar: FlutterPluginRegistrar) {
    let plugin = ScreenGeometryPlugin(registrar: registrar)
    let channel = FlutterEventChannel(
      name: "dev.biaksoy.recital/screen_geometry",
      binaryMessenger: registrar.messenger()
    )
    channel.setStreamHandler(plugin)
    registrar.publish(plugin)
  }

  private let registrar: FlutterPluginRegistrar
  private var sink: FlutterEventSink?
  private var probe: GeometryProbeView?
  private var attachAttempts = 0

  private init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    super.init()
    // A scene that reconnects brings a new Flutter view; the probe follows it.
    NotificationCenter.default.addObserver(
      self, selector: #selector(attach),
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    sink = events
    attachAttempts = 0
    attach()
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    sink = nil
    probe?.removeFromSuperview()
    probe = nil
    return nil
  }

  /// The view controller arrives after the engine, so a listener that comes early waits for
  /// it. A probe left on a view that is no longer the Flutter view, or out of its window, is
  /// replaced.
  @objc private func attach() {
    guard sink != nil else { return }
    let host = registrar.viewController?.view
    if let probe, probe.window != nil, probe.superview === host { return }
    probe?.removeFromSuperview()
    probe = nil
    guard let host else {
      attachAttempts += 1
      if attachAttempts < 40 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in self?.attach() }
      }
      return
    }
    let probe = GeometryProbeView(frame: host.bounds)
    probe.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    probe.isUserInteractionEnabled = false
    probe.isHidden = true
    probe.onChange = { [weak self] geometry in self?.sink?(geometry) }
    host.insertSubview(probe, at: 0)
    self.probe = probe
    probe.report()
  }
}

/// An invisible view over the Flutter view that reads the geometry in `layoutSubviews`.
/// UIKit tracks the reserved regions and traits read there and lays the view out again when
/// they change, which is the only change notice iOS 27.1 gives for them.
private final class GeometryProbeView: UIView {
  var onChange: (([String: Any]) -> Void)?
  private var hingeStatus = 0
  private var hingeAngle = 0.0
  private var last: NSDictionary?

  override init(frame: CGRect) {
    super.init(frame: frame)
    if #available(iOS 27.1, *) {
      addInteraction(
        UIHingeInteraction { [weak self] _, update in
          guard let self else { return }
          self.hingeStatus = update.hinge.map { $0.status.rawValue } ?? 0
          self.hingeAngle = update.hinge.map { Double($0.angle) * 180 / .pi } ?? 0
          self.setNeedsLayout()
          self.report()
        })
    }
    NotificationCenter.default.addObserver(
      self, selector: #selector(report),
      name: UIApplication.didBecomeActiveNotification, object: nil)
  }

  required init?(coder: NSCoder) { fatalError("not used from a storyboard") }

  override func layoutSubviews() {
    super.layoutSubviews()
    report()
  }

  override func didMoveToWindow() {
    super.didMoveToWindow()
    report()
  }

  @objc func report() {
    var geometry: [String: Any] = [
      "hinge": hingeStatus,
      "hingeAngle": hingeAngle,
    ]
    if let screen = window?.windowScene?.screen {
      geometry["screen"] = [screen.bounds.width, screen.bounds.height]
    }
    if #available(iOS 27.1, *) {
      geometry["divisions"] = regions(.division)
      geometry["occlusions"] = regions(.occlusion)
      let leftToRight = effectiveUserInterfaceLayoutDirection == .leftToRight
      switch traitCollection.verticalBarEdge {
      case .leading: geometry["barEdge"] = leftToRight ? "left" : "right"
      case .trailing: geometry["barEdge"] = leftToRight ? "right" : "left"
      default: break
      }
    }
    let snapshot = geometry as NSDictionary
    guard snapshot != last else { return }
    last = snapshot
    onChange?(geometry)
  }

  @available(iOS 27.1, *)
  private func regions(_ kind: UIView.ReservedRegion.Kind) -> [[Double]] {
    reservedRegions(kind: kind, options: .includeInactive).map { region in
      let frame = region.frame
      return [
        frame.minX, frame.minY, frame.width, frame.height, region.isActive ? 1 : 0,
      ].map { Double($0) }
    }
  }
}
