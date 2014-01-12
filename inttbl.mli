type 'a t

val create : unit -> 'a t

val add : 'a t -> key:int -> data:'a -> unit

val find : 'a t -> int -> 'a option

val remove : 'a t -> int -> unit

val iter : 'a t -> f:(key:int -> data:'a -> unit) -> unit

val map : 'a t -> f:('a -> 'b) -> 'b t

val filter : 'a t -> f:('a -> bool) -> 'a t

val filteri : 'a t -> f:(key:int -> data:'a -> bool) -> 'a t

