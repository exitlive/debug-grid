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


  @published bool visible = false;


  @published bool showLines = true;

  /// Whether to show 12 columns or just 6
  @published bool cols12 = false;

  DebugGridElement.created() : super.created();


  /**
   * Sets up the key listeners to toggle the grid
   */
  ready() {
    window.onKeyDown.listen((KeyboardEvent e) {
      if (e.target is! InputElement && e.target is! TextAreaElement) {
        if (e.keyCode == toggleKey) {
          if (e.shiftKey) toggle12columns();
          else toggleVisibility();
        }
      }
    });
  }

  /**
   * Adds all elements needed to show the lines
   */
  attached() {
    var numberOfLines = 100,
        linesHtml = '';
    for (var i = 0; i < numberOfLines; i++) {
      linesHtml += '<div></div>';
    }
    shadowRoot.querySelector('#lines').appendHtml(linesHtml);
  }


  toggleVisibility() {
    visible = !visible;
  }

  /**
   * Toggles the [cols12] property and makes sure that the grid is visible
   */
  toggle12columns() {
    cols12 = !cols12;
    visible = true;
  }

}

