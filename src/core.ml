module Option = Option
module Either = Either

type ('a, 'b) either = ('a, 'b) Either.t

module Array  = Core_array
module List   = Core_list
module String = Core_string
module Arrow  = Arrow
module Queue  = Core_queue
module Inttbl = Inttbl
module Monad  = Monad

module Time = Time

let string_of_float x = Js.to_string ((Js.number_of_float x)##toString())

let mod_float : float -> float -> float =
  let js_mod = Js.Unsafe.eval_string "(function(x,y){return x % y;})" in
  fun x y ->
    Js.Unsafe.(fun_call js_mod [| inject x; inject y |])

let set_global s x =
  Js.Unsafe.(set (variable "window") (Js.string s) x)

let print x : unit = 
  Js.Unsafe.(fun_call (variable "console.log") [| inject x |])

let println s : unit = print (Js.string s)

let set_timeout (ms : float) ~(f:unit -> unit) : unit =
  Js.Unsafe.(
    fun_call (variable "setTimeout")
      [| inject (Js.wrap_callback f); inject (Js.number_of_float ms) |]
  )

let set_interval (ms : float) ~(f:unit -> unit) : unit =
  Js.Unsafe.(
    fun_call (variable "setInterval")
      [| inject (Js.wrap_callback f); inject (Js.number_of_float ms) |]
  )

let ident x = x

let (|>) x f = f x
