@HtmlImport('debug_grid.html')
library debug_grid.polymer_element;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

import 'package:cookie/cookie.dart' as cookie;
import 'package:logging/logging.dart';

/// Displays a debug grid to verify if all elements are properly aligned.
///
/// Toggle this debug grid with the `g` shortcut.
/// Toggle the number of columns with the shift key.
@PolymerRegister('debug-grid')
class DebugGrid extends PolymerElement {
  DebugGrid.created() : super.created() {
    String setting;

    setting = cookie.get('${name}-visible');
    if (setting != null) set('visible', (setting == '1'));

    setting = cookie.get('${name}-show-lines');
    if (setting != null) set('showLines', (setting == '1'));

    setting = cookie.get('${name}-show-columns');
    if (setting != null) set('showColumns', (setting == '1'));

    setting = cookie.get('${name}-columns');
    if (setting != null) set('columns', int.parse(setting));

    _isInitialized = true;
  }

  bool _isInitialized = false;

  var log = new Logger('Debug Grid');

  /// This is used to create the names for cookies
  /// If you have multiple debug grids, you should use different
  /// names here
  @property
  String name = 'debug-grid';

  /// The key that toggles the visibility of the grid.
  /// Use Shift together with it to toggle between 6 and 12 columns
  @property
  int toggleKey = KeyCode.G;

  /// The key that toggles the visibility of the lines.
  /// Use Shift together with this key to toggle the grid instead.
  @property
  int linesToggleKey = KeyCode.L;

  /// Whether any of the debug grid is visible.
  /// Can be toggled with [toggleKey]
  @property
  bool visible = false;

  @Observe('visible')
  visibilityChanged([_]) {
    if (_isInitialized) {
      log.info('${visible ? 'Showing' : 'Hiding'} [$name]');
      _saveSetting('visible', visible ? '1' : '0');
    }
  }

  /// Whether to display debug lines
  /// Can be toggled with [linesToggleKey]
  @property
  bool showLines = false;

  /// Whether to display debug columns.
  /// Can be toggled with Shift - [linesToggleKey]
  @property
  bool showColumns = true;

  /// The total width in pixels (without gutters on the outside)
  @property
  num totalWidth = 70.5;

  /// The gutter width in pixels
  @property
  num gutterWidth = 1.5;

  /// The line height in pixels
  @property
  num lineHeight = 1.5;

  /// The units used for all measurements (totalWidth, gutterWidth, etc...)
  @property
  String units = 'rem';

  /// Whether the grid should get smaller if the window size gets smaller
  @property
  bool adaptive = true;

  /// The number of columns to display
  @property
  int columns = 6;

  /// Invoked whenever [columns] changed and makes sure that the correct amount
  /// of columns are displayed
  @Observe('columns')
  columnsChanged([_]) {
    if (_isInitialized) {
      log.info('Setting columns to $columns [$name]');
      _setColumnsHtml();
      _saveSetting('columns', columns.toString());
    }
  }

  @property
  String containerClass = '';

  @property
  String columnsClass = 'visible';

  @Observe('showColumns')
  columnsVisibilityChanged([_]) {
    set('columnsClass', showColumns ? 'visible' : '');
    if (_isInitialized) {
      log.info('${showColumns ? 'Showing' : 'Hiding'} columns [$name]');
      _saveSetting('show-columns', showColumns ? '1' : '0');
    }
  }

  @property
  String linesClass = 'visible';

  @Observe('showLines')
  linesVisibilityChanged([_]) {
    set('linesClass', showLines ? 'visible' : '');
    if (_isInitialized) {
      log.info('${showLines ? 'Showing' : 'Hiding'} lines [$name]');
      _saveSetting('show-lines', showLines ? '1' : '0');
    }
  }

  _saveSetting(String settingName, String value) {
    if (_isInitialized) {
      cookie.set('$name-$settingName', value);
    }
  }

  /// The cookie name
  static const String COLUMNS_NAME = 'debug-grid-columns';

  /**
   * Sets up the key listeners to toggle the grid
   */
  ready() {
    window.onKeyDown.listen((KeyboardEvent e) {
      if (e.target is! InputElement && e.target is! TextAreaElement) {
        if (e.keyCode == toggleKey) {
          if (e.shiftKey)
            toggleColumnCount();
          else
            toggleVisibility();
        }
        if (e.keyCode == linesToggleKey) {
          if (e.shiftKey)
            toggleColumns();
          else
            toggleLines();
        }
      }
    });
  }

  /// Helper that appends [number] divs to given container.
  _appendDivs(Element container, int number) {
    container.setInnerHtml('');
    PolymerDom c = Polymer.dom(container);
    for (var i = 0; i < number; i++) {
      c.append(new DivElement());
    }
  }

  @Observe('visible, adaptive')
  updateContainerClass([_, __]) {
    set('containerClass', visible ? 'visible' : '');
  }

  /**
   * Adds all elements needed to show the lines
   */
  attached() {
    var numberOfLines = 100;
    _appendDivs($$('#lines'), numberOfLines);
    _setColumnsHtml();
  }

  /**
   * Gets invoked by [columnsChanged] and adds the actual amount of columns
   */
  _setColumnsHtml() {
    var containerElement = $$('#columns > div');
    _appendDivs(containerElement, columns);

    var containerWidth = '${totalWidth + gutterWidth * 2}$units';
    if (adaptive) {
      containerElement.style.maxWidth = containerWidth;
    } else {
      containerElement.style
        ..width = 'auto'
        ..maxWidth = containerWidth;
    }

    $$("#columns > div")
      ..style.paddingLeft = '${gutterWidth}$units'
      ..style.paddingRight = '${gutterWidth}$units';

    var columnWidth = ((totalWidth - (gutterWidth * (columns - 1))) / columns);
    var columnWidthPercentage = 100 * columnWidth / totalWidth;

    List<DivElement> columnElements = Polymer.dom(root).querySelectorAll('#columns > div > div');
    List<DivElement> lineElements = Polymer.dom(root).querySelectorAll('#lines > div');

    columnElements.forEach((div) {
      div.style
        ..marginRight = '${100 * gutterWidth / totalWidth}%'
        ..width = '${columnWidthPercentage}%';
    });

    lineElements.forEach((div) {
      div.style
        ..height = '${lineHeight}$units'
        ..marginTop = '${lineHeight}$units';
    });
  }

  toggleVisibility() {
    set('visible', !visible);
  }

  /**
   * Toggles the [cols12] property and makes sure that the grid is visible
   */
  toggleColumnCount() {
    if (columns != 6)
      set('columns', 6);
    else
      set('columns', 12);
    set('visible', true);
    set('showColumns', true);
  }

  toggleLines() {
    set('showColumns', true);
    set('showLines', !showLines);
  }

  toggleColumns() {
    set('showLines', true);
    set('showColumns', !showColumns);
  }
}
