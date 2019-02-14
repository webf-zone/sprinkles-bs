open Tea
open Tea.Html
open WCApp

(* This component uses Polymer's icon project *)
[%%raw "import '@polymer/iron-icon/iron-icon.js';"]
[%%raw "import '@polymer/iron-icons/iron-icons.js';"]

type model =
  {
    disabled : bool;
    value : float;
    max : int;
  }

let initialValue =
  {
    disabled = true;
    max = 5;
    value = 0.0;
  }

type msg =
  | OnRating of int
  | OnDisabled of bool
  | OnValue of float
  | OnMax of int
  | Nope
[@@bs.deriving {accessors}]

let propDecoder rawVal =
  let open Json.Decoder in
  let disabledD = oneOf
    [ field "disabled" bool
    ; succeed initialValue.disabled
    ] in
  let valD = oneOf
    [ field "value" Json.Decoder.float
    ; succeed initialValue.value
    ] in
  let maxD = oneOf
    [ field "max" int
    ; succeed initialValue.max
    ] in
    decodeValue (map3 (fun disabled value max -> { disabled; value; max }) disabledD valD maxD) rawVal


let init c flags =
  match propDecoder flags with
  | Result.Ok v -> (v, if v.disabled then c.attr "disabled" "" else Cmd.none)
  | Result.Error _err -> (initialValue, Cmd.none)

let update c (m : model) (message : msg) =
  match message with
  | OnRating newVal -> (m, if m.disabled then Cmd.none else c.send "change" newVal)
  | OnValue newVal -> ({ m with value = newVal }, Cmd.none)
  | OnMax newVal -> ({ m with max = newVal }, Cmd.none)
  | OnDisabled newVal -> ({ m with disabled = newVal }, if newVal then c.attr "disabled" "" else c.removeAttr "disabled")
  | Nope -> (initialValue, Cmd.none)

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
  (Util.range 0 m.max)

let view (m : model) =
  div
    [ classList [("rating", true)] ]
    (icons m)

let subscriptions c _m =
  let open Json.Decoder in
  Tea.Sub.batch
  [ c.prop "value" (fun y ->
      let result = decodeValue Json.Decoder.float y in
        match result with
        | Tea.Result.Error _ -> Js.Exn.raiseError "Invalid props"
        | Tea.Result.Ok v -> OnValue v)

  ; c.prop "max" (fun y ->
      let result = decodeValue int y in
        match result with
        | Result.Error _ -> Js.Exn.raiseError "Invalid props"
        | Result.Ok v -> OnMax v)

  ; c.prop "disabled" (fun y ->
      match decodeValue bool y with
      | Result.Error _ -> Js.Exn.raiseError "Invalid props"
      | Result.Ok v -> OnDisabled v)
  ]

let main = wcProgram { init; update; view; subscriptions }

let ratingProps = [| "max"; "value"; "disabled" |]
