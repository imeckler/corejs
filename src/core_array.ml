include Array

let map arr ~f = map f arr

let iter arr ~f = iter f arr

let iteri arr ~f = iteri f arr

let mapi arr ~f = mapi f arr

let init n ~f = init n f

let fold_right t ~f ~init = fold_right f t init

let fold t ~init ~f = fold_left t ~init ~f

let concat_map t ~f = concat (to_list (map ~f t))

let exists t ~f =
  let rec loop i =
    if i < 0
    then false
    else if f t.(i)
    then true
    else loop (i - 1)
  in
  loop (length t - 1)

let for_all t ~f =
  let rec loop i =
    if i < 0
    then true
    else if f t.(i)
    then loop (i - 1)
    else false
  in
  loop (length t - 1)
