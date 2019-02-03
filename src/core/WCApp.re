open Tea;
open Tea.App;

type any;
type emitCommand('msg) = string => Cmd.t('msg);
type sendCommand('msg) = (string, any) => Cmd.t('msg);

/* https://stackoverflow.com/questions/8482624/ocaml-identity-function */
external idd : 'any => any = "%identity";

type wcContext('msg) = {
  emit: emitCommand('msg),
  send: sendCommand('msg)
};

type wcSubContext('msg) = {
  prop: (string, (Js_json.t) => 'msg) => Sub.t('msg)
};

type wcUpdate('model, 'msg) = (wcContext('msg), 'model, 'msg) => ('model, Cmd.t('msg));

type wcSubscriptions('model, 'msg) = (wcSubContext('msg), 'model) => Sub.t('msg);

type wcProgram('flags, 'model, 'msg) = {
  init: 'flags => ('model, Cmd.t('msg)),
  update: wcUpdate('model, 'msg),
  view: 'model => Vdom.t('msg),
  subscriptions: wcSubscriptions('model, 'msg)
};

type rxSubscription = {
  .
  [@bs.meth] "unsubscribe": (unit) => unit
}

/* Modelling plain JavaScript Object */
type glue = {
  .
  [@bs.meth] "trigger": (string, any) => unit,
  [@bs.meth] "subscribe": (string, any) => rxSubscription
};

let send = (x: glue, eventName: string) =>
  Cmd.call(_enqueue => x##trigger(eventName, idd()));

let send2 = (x: glue, eventName: string, eventData: any) =>
  Cmd.call(_enqueue => x##trigger(eventName, eventData));

let prop = (x: glue, propName: string, tagger) => {
  open Vdom;

  let enableCall = (callbacks) => {

    let nextFn = (anyVal) => callbacks.enqueue(tagger(anyVal));

    let rxSubscription = x##subscribe(propName, idd(nextFn));

    () => rxSubscription##unsubscribe();
  };
  Tea_sub.registration("prop-" ++ propName, enableCall);
};


let makeContext = (x: glue): wcContext('msg) => {
  emit: send(x),
  send: send2(x)
};

let makeUpdate = (context: wcContext('msg), update: wcUpdate('model, 'msg)) => update(context);

let makeSubContext = (x: glue): wcSubContext('msg) => {
  prop: prop(x),
};

let makeSubscription = (context: wcSubContext('msg), sub) => sub(context);

/* Our own web component program */
let wcProgram =
    (
      program: wcProgram('flags, 'model, 'msg),
      pnode,
      args,
      glueObj: glue,
    ) => {

  let update = glueObj->makeContext->makeUpdate(program.update);

  let subscriptions = glueObj->makeSubContext->makeSubscription(program.subscriptions);

  let newProgram: standardProgram('flags, 'model, 'msg) = {
    init: program.init,
    update,
    view: program.view,
    subscriptions,
  };

  standardProgram(newProgram, pnode, args);
};