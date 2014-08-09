type t

module Infix : sig
  val (%) : int -> int -> t

  val (+%)   : t -> t -> t
  val (-%)   : t -> t -> t
  val ( *% ) : t -> t -> t
  val (/%)   : t -> t -> t

  val (>%)  : t -> t -> bool
  val (<%)  : t -> t -> bool
  val (>=%) : t -> t -> bool
  val (<=%) : t -> t -> bool
end

val numerator : t -> int

val denominator : t -> int

val to_float : t -> float

val to_pair : t -> int * int
