import 'dart:html';

import 'package:polymer/polymer.dart';


/**
 * Displays a debug grid to verify if all elements are properly aligned.
 *
 * Toggle this debug grid with the `g` shortcut.
 * Toggle the number of columns with the shift key.
 */
@CustomTag('debug-grid')
class DebugGridElement extends PolymerElement {

  /// The key that toggles the visibility of the grid.
  /// Use Shift together with it to toggle between 6 and 12 columns
  @published  int toggleKey = KeyCode.G;

  /// The key that toggles the visibility of the lines.
  /// Use Shift together with this key to toggle the grid instead.
  @published  int linesToggleKey = KeyCode.L;


  /// Whether any of the debug grid is visible.
  /// Can be toggled with [toggleKey]
  @published bool visible = false;


  /// Whether to display debug lines
  /// Can be toggled with [linesToggleKey]
  @published bool showLines = false;

  /// Whether to display debug columns.
  /// Can be toggled with Shift - [linesToggleKey]
  @published bool showColumns = true;


  /// The total width in pixels (without gutters on the outside)
  @published int totalWidth = 1128;

  /// The gutter width in pixels
  @published int gutterWidth = 24;

  /// The line height in pixels
  @published int lineHeight = 24;


  @observable double get gutterWidthPercentage => 100 * gutterWidth / totalWidth;

  @observable int get columnWidth => ((totalWidth - (gutterWidth * (columns - 1))) / columns).round();

  @observable double get columnWidthPercentage => 100 * columnWidth / totalWidth;



  @observable String color = "red";

  /// The number of columns to display
  @published int columns = 6;

  DebugGridElement.created() : super.created();

  /**
   * Sets up the key listeners to toggle the grid
   */
  ready() {
    window.onKeyDown.listen((KeyboardEvent e) {
      if (e.target is! InputElement && e.target is! TextAreaElement) {
        if (e.keyCode == toggleKey) {
          if (e.shiftKey) toggleColumnCount();
          else toggleVisibility();
        }
        if (e.keyCode == linesToggleKey) {
          if (e.shiftKey) toggleColumns();
          else toggleLines();
        }
      }
    });
  }


  /**
   * Small helper function to return a [number] of `<div>`s.
   */
  String _getDivs(int number) {
    var linesHtml = '';
    for (var i = 0; i < number; i++) {
      linesHtml += '<div></div>';
    }
    return linesHtml;
  }


  /**
   * Adds all elements needed to show the lines
   */
  attached() {
    var numberOfLines = 100;
    shadowRoot.querySelector('#lines').setInnerHtml(_getDivs(numberOfLines));
    columnsChanged();
  }


  /**
   * Invoked whenever [columns] changed and makes sure that the correct amount
   * of columns are displayed
   */
  columnsChanged() {
    shadowRoot.querySelector("#columns > div").setInnerHtml(_getDivs(columns));

    // TODO: find a better way to notify those property changes!
    notifyPropertyChange(new Symbol('columnWidth'), 0, columnWidth);
    notifyPropertyChange(new Symbol('columnWidthPercentage'), 0, columnWidthPercentage);
    notifyPropertyChange(new Symbol('gutterWidthPercentage'), 0, gutterWidthPercentage);
  }


  toggleVisibility() {
    visible = !visible;
  }

  /**
   * Toggles the [cols12] property and makes sure that the grid is visible
   */
  toggleColumnCount() {
    if (columns != 6) columns = 6;
    else columns = 12;
    visible = true;
    showColumns = true;
  }


  toggleLines() {
    showColumns = true;
    showLines = !showLines;
  }
  toggleColumns() {
    showLines = true;
    showColumns = !showColumns;
  }


}

