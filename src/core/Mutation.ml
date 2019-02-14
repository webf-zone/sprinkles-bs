type t = Dom.mutationObserver

type tConfig =
  < attributes : bool;
    childList : bool;
    subtree : bool;
  > Js.t

let config : tConfig =
  [%bs.obj {
    attributes = false;
    childList = true;
    subtree = true;
  }]

type mutationCallback = (Dom.mutationRecord array -> t -> unit)

type 'msg mutationSubscriptionCb = Dom.mutationRecord array -> 'msg

(* https://github.com/reasonml-community/bs-webapi-incubator/blob/master/src/dom/nodes/MutationObserverRe.re *)
external make : mutationCallback -> t = "MutationObserver" [@@bs.new]

external observe : t -> 'a Dom.node_like -> tConfig -> unit = "" [@@bs.send]

external disconnect : unit = "" [@@bs.send.pipe : t]

external takeRecords : Dom.mutationRecord array = "" [@@bs.send.pipe : t]

(* 1. config -> 2. callback -> 3. observer -> 4. observe ==> disconnect *)
let lightDomM elm (cb : 'msg mutationSubscriptionCb) =
  let open Vdom in
    let enableCall callbacks =
      let callback mutationList _obs = callbacks.enqueue (cb mutationList) in
      let obs = make callback in
      let _ignore = (observe obs elm config) in
      fun ()  -> disconnect obs in
    Tea.Sub.registration "lightDomM" enableCall
