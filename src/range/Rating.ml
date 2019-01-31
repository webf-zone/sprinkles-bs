open Tea
open Tea.Html
open WCApp
open Range


(* This component depends upon polymer project *)
(* LET ME TEST IT *)
[%%raw "import '@polymer/iron-icon/iron-icon.js';"]
[%%raw "import '@polymer/iron-icons/iron-icons.js';"]

let attr = Vdom.attribute

let rec range (start : int) (end_ : int) =
  if (start >= end_) then [] else start :: (range (start + 1) end_)

type msg =
  | None

let initialValue: range = { low = 0; high = 10; value = 5 }

let init (_initialCount : int) = (initialValue, Cmd.none)

let update _send (_m : range) (_message : msg) = (initialValue, Cmd.none)

let ironIcon = node "iron-icon"

let icon (type_ : string) = ironIcon [ attr "" "icon" type_ ] []

let icons (m : range) = List.map (fun _x -> icon "star") (range 0 m.high)

let view (m : range) =
  div
    [ classList [("rating", true)] ]
    (icons m)

let subscriptions _ = Sub.none

let main = wcProgram { init; update; view; subscriptions }
