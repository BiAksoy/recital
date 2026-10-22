// Sets the iPhone Duo simulator's pose by pressing the buttons Xcode's Device Hub shows
// under the device: "Closed", "Partially Open", "Open" and "Rotate Right". simctl has no
// pose command (Xcode 27.1), so this goes through the accessibility API, which needs the
// terminal to have Accessibility permission. Device Hub must be showing the device.
//
//     swiftc -O scripts/duo/duo_pose.swift -o build/duo_pose
//     build/duo_pose "Partially Open"
import ApplicationServices
import Cocoa

let name = CommandLine.arguments.dropFirst().joined(separator: " ")
// NSRunningApplication reports Device Hub's pid as -1 to a command-line tool, so ask pgrep.
let pgrep = Process()
pgrep.executableURL = URL(fileURLWithPath: "/usr/bin/pgrep")
pgrep.arguments = ["-x", "DeviceHub"]
let output = Pipe()
pgrep.standardOutput = output
try pgrep.run()
pgrep.waitUntilExit()
guard
  let line = String(data: output.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?
    .split(separator: "\n").first,
  let pid = pid_t(line)
else {
  FileHandle.standardError.write("Device Hub is not running\n".data(using: .utf8)!)
  exit(2)
}

func value(_ element: AXUIElement, _ attribute: String) -> AnyObject? {
  var result: AnyObject?
  AXUIElementCopyAttributeValue(element, attribute as CFString, &result)
  return result
}

/// Breadth first: the pose buttons sit a few levels under the window, beside the device's
/// screen, whose own accessibility tree (a keyboard, say) can be large.
func button(in window: AXUIElement) -> AXUIElement? {
  var level = [window]
  for _ in 0..<12 where !level.isEmpty {
    var next: [AXUIElement] = []
    for element in level {
      if value(element, kAXRoleAttribute) as? String == kAXButtonRole,
        value(element, kAXDescriptionAttribute) as? String == name
      {
        return element
      }
      next += value(element, kAXChildrenAttribute) as? [AXUIElement] ?? []
    }
    level = next
  }
  return nil
}

// The window is briefly unreadable while the device animates, so look again a few times.
let app = AXUIElementCreateApplication(pid)
for _ in 0..<10 {
  let windows = (value(app, kAXChildrenAttribute) as? [AXUIElement] ?? [])
    .filter { value($0, kAXRoleAttribute) as? String == kAXWindowRole }
  if let target = windows.lazy.compactMap({ button(in: $0) }).first,
    AXUIElementPerformAction(target, kAXPressAction as CFString) == .success
  {
    exit(0)
  }
  Thread.sleep(forTimeInterval: 1)
}
FileHandle.standardError.write("No Device Hub button named \"\(name)\"\n".data(using: .utf8)!)
exit(1)
