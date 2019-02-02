open Tea;
open Tea.App;

type sendCommand('msg) = string => Cmd.t('msg);

type wcContext('msg) = {
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
type dispatcher = {. [@bs.meth] "trigger": string => unit};

let send = (x: dispatcher, eventName: string) =>
  Cmd.call(_enqueue => x##trigger(eventName));

let makeContext = (x: dispatcher): wcContext('msg) => {
  send: send(x)
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