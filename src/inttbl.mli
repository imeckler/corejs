type 'a t

val create : unit -> 'a t

val add : 'a t -> key:int -> data:'a -> unit

val find : 'a t -> int -> 'a option

val find_exn : 'a t -> int -> 'a

val remove : 'a t -> int -> unit

val length : 'a t -> int

val iter : 'a t -> f:(key:int -> data:'a -> unit) -> unit

val fold : 'a t -> init:'b -> f:('b -> key:int -> data:'a -> 'b) -> 'b

val map : 'a t -> f:('a -> 'b) -> 'b t

val filter : 'a t -> f:('a -> bool) -> 'a t

val filteri : 'a t -> f:(key:int -> data:'a -> bool) -> 'a t

val to_array : 'a t -> (int * 'a) array

val keys : 'a t -> int array

val data : 'a t -> 'a array

val copy : 'a t -> 'a t

