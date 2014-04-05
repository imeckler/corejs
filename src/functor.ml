module type T = sig
  type 'a t
  val map : 'a t -> f:('a -> 'b) -> 'b t
end

module type T2 = sig
  type ('a, 'c) t
  val map : ('a, 'c) t -> f:('a -> 'b) -> ('b, 'c) t
end

module type T3 = sig
  type ('a, 'c, 'd) t
  val map : ('a, 'c, 'd) t -> f:('a -> 'b) -> ('b, 'c, 'd) t
end

