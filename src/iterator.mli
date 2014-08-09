type 'a t

val create : int -> f:(int -> 'a) -> 'a t

val for_ : int -> f:(int -> 'a t) -> 'a t

val iter : 'a t -> f:('a -> unit) -> unit

val fold : 'b t -> init:'accum -> f:('accum -> 'b -> 'accum) -> 'accum

val map : 'a t -> f:('a -> 'b) -> 'b t

