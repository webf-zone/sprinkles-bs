open Tea
open Tea.Html
open WCApp

(* This component uses Polymer's icon project *)
[%%raw "import '@polymer/iron-icon/iron-icon.js';"]
[%%raw "import '@polymer/iron-icons/iron-icons.js';"]

(* Move to WCApp.re *)
let attr (key : string) (value : string) = Vdom.attribute "" key value

(* Move to Util library *)
let rec range (start : int) (end_ : int) =
  if (start >= end_) then [] else start :: (range (start + 1) end_)

type model =
  {
    value: float;
    max : int;
  }

let initialValue =
  {
    max = 10;
    value = 5.0;
  }

type msg =
  | OnRating of int
  | OnValue of float
  | OnMax of int
  | None
[@@bs.deriving {accessors}]

let propDecoder rawVal =
  let open Json.Decoder in
  let valD = field "value" Json.Decoder.float in
  let maxD = field "max" int in
    decodeValue (map2 (fun value max -> {value;max}) valD maxD) rawVal


let init flags =
  match propDecoder flags with
  | Result.Ok v -> (v, Cmd.none)
  | Result.Error _err -> (initialValue, Cmd.none)

let update _context (m : model) (message : msg) =
  match message with
  | OnRating newVal -> ({ m with value = float_of_int(newVal) }, Cmd.none)
  | OnValue newVal -> ({ m with value = newVal }, Cmd.none)
  | OnMax newVal -> ({ m with max = newVal }, Cmd.none)
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

let icons (m : model) = List.mapi
  (fun index _x -> makeIcon index m.value)
  (range 0 m.max)

let view (m : model) =
  div
    [ classList [("rating", true)] ]
    (icons m)

let subscriptions  c _m =
  let open Json.Decoder in
  Tea.Sub.batch
  [ c.prop "value" (fun y ->
      let result = decodeValue Json.Decoder.float y in
        match result with
        | Tea.Result.Error _ -> Js.Exn.raiseError "Invalid props for rating component"
        | Tea.Result.Ok v -> OnValue v)

  ; c.prop "max" (fun y ->
      let result = decodeValue int y in
        match result with
        | Result.Error _ -> Js.Exn.raiseError "Invalid props"
        | Result.Ok v -> OnMax v)
  ]

let main = wcProgram { init; update; view; subscriptions }

let ratingProps = [| "max"; "value" |]
