
let isHTMLElement : Web.Json.t -> bool = [%raw fun arg -> "return arg instanceof HTMLElement;"]

external safeHtmlElmCast : Web.Json.t -> Dom.htmlElement = "%identity"

let htmlElement =
  Tea.Json.Decoder.Decoder
    ( fun value ->
        if isHTMLElement value then Tea.Result.Ok (safeHtmlElmCast value)
        else Tea.Result.Error "not HTMLElement")

let rec range (start : int) (end_ : int) =
  if (start >= end_) then [] else start :: (range (start + 1) end_)