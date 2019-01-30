open Tea;

/* Modelling plain JavaScript Object */
type dispatcher = Js.t({
    .
    [@bs.meth]
    trigger: (string) => unit
});

let dispatch = (eventName: string, x: dispatcher) =>
  Cmd.call(_enqueue => {
      x##trigger(eventName)
  });


