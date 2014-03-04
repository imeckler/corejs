type 'a t = 'a option

let map t ~f = match t with
  | None -> None
  | Some x -> Some (f x)
;;

let iter t ~f = match t with
  | None -> ()
  | Some x -> f x
;;

let is_none = function
  | None -> true
  | Some _ -> false
;;

let is_some = function
  | Some _ -> true
  | None   -> false
;;

let value t ~default = match t with
  | None   -> default
  | Some x -> x
;;

let value_map t ~default ~f = match t with
  | None   -> default
  | Some x -> f x

