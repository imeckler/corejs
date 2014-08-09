(* The int value is the smallest number on which the map is undefined
 * (one can think of this as the "length") *)
type 'a t =
  | Fun of (int -> 'a) * int
  | Cat of (int -> 'a t) * int

let rec map t ~f = match t with
  | Fun (g, n) -> Fun ((fun i -> f (g i)), n)
  | Cat (g, n) -> Cat ((fun i -> map ~f (g i)), n)

let iter_fun g n ~f =
  let rec loop i =
    if i = n then () else (f (g i); loop (i + 1))
  in
  loop 0

let rec iter t ~f = match t with
  | Fun (g, n) -> iter_fun g n ~f
  | Cat (g, n) -> iter_fun g n ~f:(fun t' -> iter t' ~f)
;;

let fold_fun g n ~init ~f =
  let rec loop i acc =
    if i = n then acc else loop (i + 1) (f acc (g i))
  in
  loop 0 init

let rec fold t ~init ~f = match t with
  | Fun (g, n) -> fold_fun g n ~init ~f
  | Cat (g, n) -> fold_fun g n ~init ~f:(fun acc t' ->
      fold t' ~init:acc ~f)

let create n ~f = Fun (f, n)

let for_ n ~f = Cat (f, n)
