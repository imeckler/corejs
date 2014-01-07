type 'a t = 'a option

let iter t ~f = match t with
  | None -> ()
  | Some x -> f x
;;

