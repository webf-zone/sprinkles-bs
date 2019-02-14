open Tea
open Tea.Html
open WCApp

type model =
  { anchorElm : Dom.htmlElement option;
    opened : bool;
    popperMgr : PopperJs.manager option;
  }

type msg =
  | OnAnchor of Dom.htmlElement
  | OnOpen of bool
  | OnMutation
  | Nope


let initialValue =
  { anchorElm = None;
    opened = false;
    popperMgr = None;
  }

let init _c (_flags : string) = (initialValue, Cmd.none)


let whenAnchorChange c (m : model) (newAnchor : Dom.htmlElement) =
  let popperMgr =
    match m.anchorElm, m.popperMgr with
    | Some elm, Some mgr when elm == newAnchor -> mgr
    | _ -> PopperJs.create newAnchor c.elm in
  let cmd = if m.opened then PopperJs.updateCmd popperMgr else Cmd.none in
  ({ m with popperMgr = Some popperMgr }, cmd)

let whenOpenChange (m : model) (isOpen : bool) =
  let cmd =
    match isOpen, m.popperMgr with
    | true, Some mgr -> PopperJs.updateCmd mgr
    | _ -> Cmd.none in
  ({ m with opened = isOpen }, cmd)


let update c (m : model) (message : msg) =
  match message with
  | OnAnchor anchorElm -> whenAnchorChange c m anchorElm
  | OnOpen isOpen -> whenOpenChange m isOpen
  | OnMutation -> whenOpenChange m m.opened
  | Nope -> (m, Cmd.none)

let view (m : model) =
  div
    [ classList [("popper", true)]
    ; style "display" (if m.opened then "initial" else "none")
    ]
    [ node "slot" [] []
    ]

let subscriptions c _m =
  let open Json.Decoder in
  Sub.batch
  [ c.prop "anchorElm" (fun y ->
      match decodeValue Util.htmlElement y with
      | Result.Ok anchorElm -> OnAnchor anchorElm
      | Result.Error _ -> Js.Exn.raiseError "Invalid props")
  ; c.prop "open" (fun y ->
      match decodeValue bool y with
      | Result.Ok isOpen -> OnOpen isOpen
      | Result.Error _ -> Js.Exn.raiseError "Invalid props")

  ; c.lightDomM (fun _y -> OnMutation)
  ]

let main = wcProgram { init; update; view; subscriptions; }

let popperProps = [| "anchorElm"; "open" |]
