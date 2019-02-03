open Tea
open Tea.Html
open WCApp
open Range


(* This component depends upon Polymer's icon project *)
[%%raw "import '@polymer/iron-icon/iron-icon.js';"]
[%%raw "import '@polymer/iron-icons/iron-icons.js';"]

(* Move to WCApp.re *)
let attr (key : string) (value : string) = Vdom.attribute "" key value

(* Move to Util library *)
let rec range (start : int) (end_ : int) =
  if (start >= end_) then [] else start :: (range (start + 1) end_)

let initialValue: range = { low = 0; high = 10; value = 5.0 }

type _model = {
  r : range;
}

(* Tenative prop model *)
type _propModel = {
  value : float;
  max : int;
}

type msg =
  | OnRating of int
  (* | OnSample of string *)
  | None
[@@bs.deriving {accessors}]

let init (_initialCount : int) = (initialValue, Cmd.none)

let update _send (m : range) (message : msg) =
  match message with
  | OnRating newVal -> ({ m with value = float_of_int(newVal) }, Cmd.none)
  (* | OnSample _newVal  -> (initialValue, Cmd.none) *)
  | None -> (initialValue, Cmd.none)

let ironIcon = node "iron-icon"

let icon (value : int) (iconName : string) =
  ironIcon
  [ attr "icon" iconName
  ; onClick (OnRating value)
  ] []

let makeIcon (index : int) (value : float) =
  let indexVal = float_of_int(index + 1) in
  let iconName = if indexVal <= value then "star"
    else if value > (indexVal -. 1.0) then "star-half"
    else "star-border" in
  icon (index + 1) iconName

let icons (m : range) = List.mapi
  (fun index _x -> makeIcon index m.value)
  (range 0 m.high)

let view (m : range) =
  div
    [ classList [("rating", true)] ]
    (icons m)

(* let intDecoder = let open Json.Decoder in int *)
let intDecoder = Json.Decoder.int

let subscriptions  c _m =
  Tea.Sub.batch
  [ c.prop "value" (fun y ->
      let result = Json.Decoder.decodeValue intDecoder y in
        match result with
          | Tea.Result.Error _ -> None
          | Tea.Result.Ok v -> OnRating v)
  ]

let main = wcProgram { init; update; view; subscriptions }
