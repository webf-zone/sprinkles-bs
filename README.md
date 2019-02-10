# Sprinkles
## Reasonable and sane web components

## How to run

- `npm install`
- For Windows users, change the `ppx-flags` configuration inside `bsconfig.json` to the following:
```
"ppx-flags": ["./node_modules/ppx-tea-jsx/ppx.exe"]
```
- For VSCode, we recommend the `reason-vscode` plug-in to compile the ReasonML or OCaml to JavaScript. Use `npx bsb -make-world -w` when the `.ml` or `.re` files aren't automatically compiled to `.js` by your editor's language server plug-in.
- `npm run dev` - keep it running in a terminal window
- `npm run storybook` - keep it running in a terminal window
- Open a browser and navigate to `http://localhost:9001`
