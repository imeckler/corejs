type 'a t = 'a Js.js_array Js.t

let create () = jsnew Js.array_empty ()

let enqueue t x = let _ = t##push(x) in ()

let dequeue t = Js.Optdef.to_option (t##shift())

let dequeue_exn t =
  let x = t##shift() in
  if Js.Optdef.test x
  then Obj.magic x
  else failwith "Queue.dequeue_exn: Queue empty"
;;

let peek t = Js.Optdef.to_option (Js.array_get t 0)

let peek_exn t =
  let x = Js.array_get t 0 in
  if Js.Optdef.test x
  then Obj.magic x
  else failwith "Queue.peek_exn: Queue empty"
;;

let namespace = Js.Unsafe.obj [||]

let () =
  let js_iter = Js.Unsafe.eval_string
    "(function(a,f){var len=a.length;for(var i = 0; i < len; ++i){f(a[i]);}})"
  in
  Js.Unsafe.set namespace "iter" js_iter
;;

let iter t ~f =
  Js.Unsafe.(fun_call (get namespace "iter") [| inject t; inject (Js.wrap_callback f) |])

let map t ~f =
  let t' = create () in
  iter t ~f:(fun x -> enqueue t' (f x))

(*
  let js_map = Js.Unsafe.eval_string
    "function(a,f){var len=a.length;var res=[];for(var i=0; i<len; ++i){res.push(f(a[i]));}}"
  in
*)

let filter t ~f =
  let t' = create () in
  iter t ~f:(fun x -> if f x then enqueue t' x)

let of_list xs =
  let t = create () in
  Core_list.iter ~f:(fun x -> enqueue t x) xs;
  t

