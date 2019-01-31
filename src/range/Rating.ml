open Tea
open Tea.Html
open WCApp
open Range

let attr = Vdom.attribute

type msg =
  | None

let initialValue: range = { low = 0; high = 10; value = 5 }

let init (_initialCount : int) = (initialValue, Cmd.none)

let update _send (_m : range) (_message : msg) = (initialValue, Cmd.none)

let view (m : range) =
  div
    [ classList [("rating", true)] ]
    [ node "iron-icon"
      [ attr "" "icon" "star" ]
      []
    ; text (string_of_int m.low)
    ]

let subscriptions _ = Sub.none

let main = wcProgram { init; update; view; subscriptions }

