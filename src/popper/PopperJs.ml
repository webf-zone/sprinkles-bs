(* Hack since default imports are not supported *)
[%%raw "import Popper from 'popper.js';"]

type manager =
  < scheduleUpdate : unit -> unit [@bs.meth];
  > Js.t

type elm = Dom.htmlElement

external popper : elm -> elm -> manager = "Popper" [@@bs.new]

let create (anchorElm : elm) (contentElm : elm) = popper anchorElm contentElm

let updateCmd (mgr : manager) = Tea.Cmd.call
  (fun _enqueue ->
    let cb _ = mgr##scheduleUpdate () in
    ignore (Web.Window.requestAnimationFrame cb))

(* Till the default import is supported *)
(* external popper : elm -> elm -> popper = "popper.js" [@@bs.new] [@@bs.default] [@@bs.module] *)

