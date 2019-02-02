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

type wcUpdate('model, 'msg) =
  (wcContext('msg), 'model, 'msg) => ('model, Cmd.t('msg));

type wcProgram('flags, 'model, 'msg) = {
  init: 'flags => ('model, Cmd.t('msg)),
  update: wcUpdate('model, 'msg),
  view: 'model => Vdom.t('msg),
  subscriptions: 'model => Sub.t('msg),
};

/* Modelling plain JavaScript Object */
type dispatcher = {. [@bs.meth] "trigger": (string, any) => unit};

let send = (x: dispatcher, eventName: string) =>
  Cmd.call(_enqueue => x##trigger(eventName, idd()));

let send2 = (x: dispatcher, eventName: string, eventData: any) =>
  Cmd.call(_enqueue => x##trigger(eventName, eventData));

let makeContext = (x: dispatcher): wcContext('msg) => {
  emit: send(x),
  send: send2(x)
};

let makeUpdate = (context: wcContext('msg), update: wcUpdate('model, 'msg)) => update(context);

/* Our own web component program */
let wcProgram =
    (
      program: wcProgram('flags, 'model, 'msg),
      pnode,
      args,
      dispatcher: dispatcher,
    ) => {
  let update = dispatcher->makeContext->makeUpdate(program.update);

  let newProgram: standardProgram('flags, 'model, 'msg) = {
    init: program.init,
    update,
    view: program.view,
    subscriptions: program.subscriptions,
  };

  standardProgram(newProgram, pnode, args);
};