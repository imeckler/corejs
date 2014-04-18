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

let filter_opt t =
  let n = length t in
  let res_size = ref 0 in
  let first_some = ref None in
  for i = 0 to n - 1 do
    begin match t.(i) with
    | None -> ()
    | Some _ as s ->
      if !res_size = 0 then first_some := s;
      incr res_size;
    end;
  done;
  match !first_some with
  | None -> [||]
  | Some el ->
    let result = create ~len:!res_size el in
    let pos = ref 0 in
    for i = 0 to n - 1 do
      begin match t.(i) with
      | None -> ()
      | Some x ->
        result.(!pos) <- x;
        incr pos;
      end;
    done;
    result

let filter_map t ~f = filter_opt (map t ~f)

let filter_mapi t ~f = filter_opt (mapi t ~f)

let filter ~f =  filter_map ~f:(fun x -> if f x then Some x else None)

let filteri ~f = filter_mapi ~f:(fun i x -> if f i x then Some x else None)
