type 'a t = 'a option

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

let value_exn = function
  | None -> failwith "Option.value_exn: None"
  | Some x -> x
;;

let value_map t ~default ~f = match t with
  | None   -> default
  | Some x -> f x

include Monad.Make (struct
  type 'a t = 'a option
  let return x = Some x
  let map t ~f =
    match t with
    | None -> None
    | Some a -> Some (f a)
  ;;
  let bind o f =
    match o with
    | None -> None
    | Some x -> f x
end)
