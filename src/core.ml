module Option = Option
module Either = Either

type ('a, 'b) either = ('a, 'b) Either.t

module Array   = Core_array
module List    = Core_list
module String  = Core_string
module Arrow   = Arrow
module Queue   = Core_queue
module Inttbl  = Inttbl
module Functor = Functor
module Monad   = Monad

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

type timeout
let set_timeout (ms : float) ~(f:unit -> unit) : timeout =
  Js.Unsafe.(
    fun_call (variable "setTimeout")
      [| inject (Js.wrap_callback f); inject (Js.number_of_float ms) |]
  )

let clear_timeout (timeout : timeout) : unit =
  let open Js.Unsafe in
  fun_call (variable "clearTimeout") [| inject timeout |]

type interval
let set_interval (ms : float) ~(f:unit -> unit) : interval =
  Js.Unsafe.(
    fun_call (variable "setInterval")
      [| inject (Js.wrap_callback f); inject (Js.number_of_float ms) |]
  )

let clear_interval (interval : interval) : unit =
  let open Js.Unsafe in
  fun_call (variable "clearInterval") [| inject interval |]

let ident x = x

let (|>) x f = f x
