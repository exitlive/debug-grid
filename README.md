# Debug Grid

Just include it in your project, and you can overlay a debug grid with the
`g` Key.

Protips:

- press `Shift - g` to toggle between 6 and 12 columns.
- press `l` to display lines as well
- press `Shift - l` to toggle the visibility of columns only



## Dependency

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  debug_grid: any
```


## Use


In your html, just include the grid like this:

```html
<link rel="import" href="packages/debug_grid/debug_grid.html">
```

and put this at the end of your `body` tag:

```html
<debug-grid></debug-grid>
```

That's it, your good to go!


> I'm assuming you have already a project setup with polymer! If not, please
> refer to the polymer dart documentation on how to do that, because this grid
> will not work otherwise.


## Configuration

Here is a fully configured debug grid:

```html
<debug-grid totalWidth="1128"
            gutterWidth="24"
            lineHeight="24"
            columns="3"
            showColumns="false"
            showLines="true"
            visible="true"
            toggleKey="83"
            linesToggleKey="86"
            ></debug-grid>
```

This would display a `1128px` wide grid with `24px` wide gutters, `24px` line
height and 3 columns.
By default it is visible and would not show columns, but only lines (which can be toggled
with the appropriate keys).

The visibility toggle key has been remapped to `83` (== `s`) and the lines
toggle key has been remapped to `86` (== `v`).