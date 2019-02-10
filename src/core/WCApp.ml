open Tea
open Tea.App

(* https://stackoverflow.com/questions/8482624/ocaml-identity-function *)
(* external idd : 'any => any = "%identity"; *)

type 'msg wcContext =
  {
    emit : string -> 'msg Cmd.t;
    send : 'any. string -> 'any -> 'msg Cmd.t;

    attr : string -> string -> 'msg Cmd.t;
    removeAttr : string -> 'msg Cmd.t;
  }

type 'msg wcSubContext =
  {
    (* Note that this function take two arguments and not three
       Second arugments itself is a callback
    *)
    prop : string -> (Js_json.t -> 'msg) -> 'msg Sub.t
  }

type ('model, 'msg) wcSubscriptions = 'msg wcSubContext -> 'model -> 'msg Sub.t

(* ('model* 'msg Cmd.t) is equivalent to ('model, Cmd.t('msg)); *)
type ('model, 'msg) wcUpdate = 'msg wcContext -> 'model -> 'msg -> ('model* 'msg Cmd.t)

(* This is nominal typing *)
type ('flags, 'model, 'msg) wcProgram =
  {
    init : 'msg wcContext -> 'flags -> ('model* 'msg Cmd.t);
    update : ('model, 'msg) wcUpdate;
    view : 'model -> 'msg Vdom.t;
    subscriptions : ('model, 'msg) wcSubscriptions;
  }

(* This is structural typing *)
type rxSubscription =
  <
    unsubscribe : (unit) -> unit [@bs.meth];
  > Js.t

class type _jsContext = object
    method attr: string -> string -> unit
    method removeAttr: string -> unit
    method trigger : 'any. string -> 'any -> unit
    method subscribe : 'any. string -> 'any -> rxSubscription
  end [@bs]

type jsContext = _jsContext Js.t

let prop (x : jsContext) (propName : string) tagger =
  let open Vdom in
    let enableCall callbacks =
      let nextFn anyVal = callbacks.enqueue (tagger anyVal) in
      let rxSubscription = x##subscribe propName nextFn in
      fun ()  -> rxSubscription##unsubscribe () in
    Tea_sub.registration ("prop-" ^ propName) enableCall

(* This is a different way to annotate functions *)
let makeContext : jsContext -> 'msg wcContext =
  fun x ->
    let emit eventName =
      Cmd.call (fun _enqueue -> x##trigger eventName ()) in
    let send eventName payload =
      Cmd.call (fun _enqueue -> x##trigger eventName payload) in
    let attr attributeName attributeValue =
      Cmd.call (fun _enqueue -> x##attr attributeName attributeValue) in
    let removeAttr attributeName =
      Cmd.call (fun _enqueue -> x##removeAttr attributeName) in
    { emit; send; attr; removeAttr }

let makeUpdate (context : 'msg wcContext) (update : ('model, 'msg) wcUpdate) = update context

let makeSubContext: jsContext -> 'msg wcSubContext =
  fun x -> { prop = (prop x) }

let makeSubscription (context : 'msg wcSubContext) sub = sub context

let makeInit (context : 'msg wcContext) init = init context

let wcProgram (program : ('flags, 'model, 'msg) wcProgram) pnode args (glueObj : jsContext) =

  let context = makeContext glueObj in
  let init = makeInit context program.init in
  let update = makeUpdate context program.update in
  let subscriptions =
    (glueObj |. makeSubContext |. makeSubscription) program.subscriptions in

  let stdProgram : ('flags, 'model, 'msg) standardProgram =
    { init; update; view = (program.view); subscriptions; } in

  standardProgram stdProgram pnode args
