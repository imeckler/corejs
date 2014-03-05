type 'a t

val iter : 'a t -> f:('a -> unit) -> unit

val map : 'a t -> f:('a -> 'b) -> 'b t

val filter : 'a t -> f:('a -> bool) -> 'a t

val create : unit -> 'a t

val enqueue : 'a t -> 'a -> unit

val dequeue : 'a t -> 'a option

val dequeue_exn : 'a t -> 'a

val peek : 'a t -> 'a option

val peek_exn : 'a t -> 'a

val of_array : 'a array -> 'a t

val to_array : 'a t -> 'a array

val of_list : 'a list -> 'a t
(* val to_list : 'a t -> 'a list *)

