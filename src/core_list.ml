(* TODO: Come up with a more principled approach than copying and pasting bits *)
module List = List

let iter xs ~f = List.iter f xs

let map xs ~f = List.map f xs

let rev_map xs ~f = List.rev_map f xs

let filter xs ~f = List.filter f xs

let fold xs ~init ~f = List.fold_left f init xs

let fold_left = fold

let fold_right xs ~f ~init = List.fold_right f xs init

let rec filter_map xs ~f = match xs with
  | [] -> []
  | x :: xs ->
    match f x with
    | None -> filter_map ~f xs
    | Some y -> x :: filter_map ~f xs
;;

let rec concat_map xs ~f = match xs with
  | [] -> []
  | x :: xs -> f x @ concat_map ~f xs
;;

let rec partition_map xs ~f = match xs with
  | [] -> ([], [])
  | x :: xs ->
    let (ls, rs) = partition_map ~f xs in
    match f x with
    | Either.InL y -> (y :: ls, rs)
    | Either.InR y -> (ls, y :: rs)
;;

let init n ~f =
  if n < 0 then failwith "List.init: n < 0";
  let rec loop i accum =
    assert (i >= 0);
    if i = 0 then accum
    else loop (i-1) (f (i-1) :: accum)
  in
  loop n []

let rec partition xs ~f = match xs with
  | []     -> ([], [])
  | x :: xs ->
    let (ts, fs) = partition ~f xs in
    if f x then (x :: ts, fs) else (ts, x :: fs)
;;

let find_map t ~f =
  let rec loop = function
    | [] -> None
    | x :: l ->
        match f x with
        | None -> loop l
        | Some _ as r -> r
  in
  loop t
;;

let find t ~f =
  let rec loop = function
    | [] -> None
    | x :: l -> if f x then Some x else loop l
  in
  loop t
;;

let find_exn t ~f = List.find t ~f

let findi t ~f =
  let rec loop i t =
    match t with
    | [] -> None
    | x :: l -> if f i x then Some (i, x) else loop (i + 1) l
  in
  loop 0 t
;;
module Assoc = struct

  type ('a, 'b) t = ('a * 'b) list

  let find t ?(equal=(=)) key =
    match find t ~f:(fun (key', _) -> equal key key') with
    | None -> None
    | Some x -> Some (snd x)

  let find_exn t ?(equal=(=)) key =
    match find t key ~equal with
    | None -> raise Not_found
    | Some value -> value

  let mem t ?(equal=(=)) key = (find t ~equal key) <> None

  let remove t ?(equal=(=)) key =
    filter t ~f:(fun (key', _) -> not (equal key key'))

  let add t ?(equal=(=)) key value =
    (* the remove doesn't change the map semantics, but keeps the list small *)
    (key, value) :: remove t ~equal key

  let inverse t = map t ~f:(fun (x, y) -> (y, x))

  let map t ~f = map t ~f:(fun (key, value) -> (key, f value))
end
