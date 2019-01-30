/* opens the Tea.App modules into the current scope for Program access functions and types */
open Tea.App;
open Tea;
open Tea.Html;
open Dispatcher;

module Task = Tea_task;

[@bs.deriving
  {
    accessors;
  }
]
type msg =
  | Increment
  | Decrement
  | Reset
  | Set(int);

type model = {
  x: dispatcher,
  count: int
};

let init = (dsp: dispatcher) => ({ x: dsp, count: 10 }, Cmd.none);


let update = (m: model, message: msg) =>
  switch (message) {
  | Increment => ({...m, count: m.count + 1 }, dispatch("increment", m.x))
  | Decrement => ({...m, count: m.count - 1 }, dispatch("decrement", m.x))
  | Reset => ({...m, count: 10}, Cmd.none)
  | Set(value) => ({...m, count: value}, Cmd.none)
  };

let viewButton = (title: string, message: msg) =>
  <button onClick={_e => Some(message)}>
    <span> {text(title)} </span>
  </button>;

let view = (model: model) =>
  <div>
    {viewButton("Increment", Increment)}
    {viewButton("Decrement", Decrement)}
    <div> "Counter value is:" {text(string_of_int(model.count))} </div>
  </div>;

let subscriptions = _ => Sub.none;

let main = standardProgram({init, update, view, subscriptions});
/* let main = beginnerProgram({model: init(), update, view}); */
