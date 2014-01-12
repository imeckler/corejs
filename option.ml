type 'a t = 'a option

let map t ~f = match t with
  | None -> None
  | Some x -> Some (f x)
;;

let iter t ~f = match t with
  | None -> ()
  | Some x -> f x
;;

