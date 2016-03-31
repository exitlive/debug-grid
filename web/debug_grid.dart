library exitlive.webserver.entry_point;

import 'package:polymer/polymer.dart';
import 'package:debug_grid/debug_grid.dart';
import 'package:logging/logging.dart';

/// Uses [DebugGrid]
main() {

  Logger.root.onRecord.listen(print);

  initPolymer();

}
