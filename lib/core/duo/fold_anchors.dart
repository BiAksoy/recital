import 'package:flutter/widgets.dart';
import 'package:recital/core/duo/screen_layout.dart';

/// Where a dialog opens while iPhone Duo is partially open, as `anchorPoint` (DEC-3):
/// on the right half when it is folded like a book, close to where the outer display
/// will show it if the device closes, and on the upper half when it rests on a table, to
/// be read from a distance, as Apple places alerts. The fold is in
/// [MediaQueryData.displayFeatures] then ([ScreenLayoutScope]); without one the anchor
/// does nothing. A corner rather than a measured point, so it holds as the fold moves.
const foldDialogAnchor = Offset(100000, 0);

/// Where a sheet of choices opens while iPhone Duo is partially open: the right half like
/// a book, and the lower half on a table, the half that rests on it and takes a tap
/// without wobbling, where Apple puts controls.
const foldSheetAnchor = Offset(100000, 100000);

/// Whether a sheet should keep to the safe area: on iPhone Duo with bars on the side, so
/// the sheet stops beside the status bar's column rather than under it, as the system's
/// sheets do. Elsewhere sheets keep the reach they had.
bool sheetUsesSafeArea(BuildContext context) =>
    ScreenLayout.columnOf(context) != null;
