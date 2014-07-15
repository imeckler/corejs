(* TODO: Come up with a more principled approach than copying and pasting bits *)
module List = List

let range ?(stride=1) ?(start=`inclusive) ?(stop=`exclusive) start_i stop_i =
  if stride = 0 then
    invalid_arg "Core_list.range: stride must be non-zero";
  (* Generate the range from the last element, so that we do not need to rev it *)
  let rec loop last counter accum =
    if counter <= 0 then accum
    else loop (last - stride) (counter - 1) (last :: accum)
  in
  let stride_sign = if stride > 0 then 1 else -1 in
  let start =
    match start with
    | `inclusive -> start_i
    | `exclusive -> start_i + stride
  in
  let stop =
    match stop with
    | `inclusive -> stop_i + stride_sign
    | `exclusive -> stop_i
  in
  let num_elts = (stop - start + stride - stride_sign) / stride in
  loop (start + (stride * (num_elts - 1))) num_elts []
;;

let unzip list =
  let rec loop list l1 l2 =
    match list with
    | [] -> (List.rev l1, List.rev l2)
    | (x, y) :: tl -> loop tl (x :: l1) (y :: l2)
  in
  loop list [] []

let length = List.length

let iteri xs ~f = List.iteri f xs

let iter xs ~f = List.iter f xs

let map xs ~f = List.map f xs

let mapi xs ~f = List.mapi f xs

let map2_exn xs ys ~f = List.map2 f xs ys

let rev_map xs ~f = List.rev_map f xs

let rev = List.rev

let filter xs ~f = List.filter f xs

let fold xs ~init ~f = List.fold_left f init xs

let fold_left = fold

let fold_right xs ~f ~init = List.fold_right f xs init

let rec filter_map xs ~f = match xs with
  | [] -> []
  | x :: xs ->
    match f x with
    | None -> filter_map ~f xs
    | Some y -> y :: filter_map ~f xs
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
