type 'a t

val create : unit -> 'a t

val find : 'a t -> string -> 'a option

val add : 'a t -> key:string -> data:'a -> unit

val remove : 'a t -> string -> unit

val iter : 'a t -> f:(key:string -> data:'a -> unit) -> unit

val fold : 'a t -> init:'b -> f:(key:string -> data:'a -> 'b -> 'b) -> 'b

val copy : 'a t -> 'a t

val length : 'a t -> int

val mem : 'a t -> string -> bool

val map : 'a t -> f:('a -> 'b) -> 'b t
val mapi : 'a t -> f:(key:string -> data:'a -> 'b) -> 'b t

val filter : 'a t -> f:('a -> bool) -> 'a t
val filteri : 'a t -> f:(key:string -> data:'a -> bool) -> 'a t

val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
val filter_mapi : 'a t -> f:(key:string -> data:'a -> 'b option) -> 'b t
