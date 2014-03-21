include Array

let map arr ~f = map f arr

let iter arr ~f = iter f arr

let iteri arr ~f = iteri f arr

let mapi arr ~f = mapi f arr

let init n ~f = init n f

let create ~len x = create len x

let fold_right t ~f ~init = fold_right f t init

let fold t ~init ~f = fold_left f init t

let concat_map t ~f = concat (to_list (map ~f t))

let push (x : 'a) (t : 'a array) =
  ignore ((Obj.magic t : 'a Js.js_array Js.t)##push(x))

let exists t ~f =
  let rec loop i =
    if i < 0
    then false
    else if f t.(i)
    then true
    else loop (i - 1)
  in
  loop (length t - 1)

let mem ?(eq=(=)) t x0 = exists t ~f:(fun x -> eq x x0)

let findi t ~f =
  let length = length t in
  let rec loop i =
    if i >= length then None
    else if f i t.(i) then Some (i, t.(i))
    else loop (i + 1)
  in
  loop 0
;;

let find t ~f = Option.map (findi t ~f:(fun _i x -> f x)) ~f:(fun (_i, x) -> x)

let for_all t ~f =
  let rec loop i =
    if i < 0
    then true
    else if f t.(i)
    then loop (i - 1)
    else false
  in
  loop (length t - 1)
