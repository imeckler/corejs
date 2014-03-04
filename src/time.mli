type t

val now : unit -> t

val to_ms : t -> float

module Span : sig
  type t

  val to_ms : t -> float

  val of_ms : float -> t

  val (+) : t -> t -> t

  val (-) : t -> t -> t

  val (/) : t -> t -> float
end

val (-) : t -> t -> Span.t

val (+) : t -> Span.t -> t

val to_string : t -> string

(* val diff : t -> t -> Span.t *)

(* val of_ms : int -> t *)

(* c dur^3 = (x_1 - x_0)
*)
