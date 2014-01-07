module Option = Option
module Either = Either

type ('a, 'b) either = ('a, 'b) Either.t

module Array = Core_array
module List = Core_list
module Arrow = Arrow

let set_global s x =
  Js.Unsafe.(set (variable "window") (Js.string s) x)

let print x : unit = 
  Js.Unsafe.(fun_call (variable "console.log") [| inject x |])

let println s : unit = print (Js.string s)

