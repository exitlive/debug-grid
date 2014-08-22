# Debug Grid

Just include it in your project, and you can overlay a debug grid with the
`g` Key.

Protip: Press `Shift - g` to toggle between 6 and 12 columns.



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