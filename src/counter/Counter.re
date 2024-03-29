/* opens the Tea.App modules into the current scope for Program access functions and types */
open Tea;
open Tea.Html;

open WCApp;

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
  count: int
};

let init = (_c, _initialCount: int) => ({ count: 10 }, Cmd.none);

let update = (c, m: model, message: msg) =>
  switch (message) {
  | Increment => ({count: m.count + 1}, c.send("increment", m.count + 1))
  | Decrement => ({count: m.count - 1}, c.send("decrement", m.count - 1))
  | Reset => ({count: 10}, Cmd.none)
  | Set(value) => ({count: value}, Cmd.none)
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

let subscriptions2 = _ => Sub.none;

let subscriptions = (_c, m: model) =>
  if (m.count >= 10 && m.count < 20) {
    Tea_time.every("KeyTime", 1000.0, (_val) => Increment);
  } else {
    Sub.none
  }

let main = wcProgram({init, update, view, subscriptions});
