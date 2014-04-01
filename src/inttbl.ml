(* Silly hack to make polymorphic equality work *)
type 'a t = 'a array

let inttbl = Js.Unsafe.obj [|
  "iter", Js.Unsafe.eval_string "(function(t, f){for(var k in t){if(t.hasOwnProperty(k)){f(parseInt(k),t[k]);}}})";
  "fold", Js.Unsafe.eval_string "(function(t, x0, f){for(var k in t){if(t.hasOwnProperty(k)){x0=f(x0,parseInt(k),t[k]);}} return x0;})"
|]

let print x : unit =
  Js.Unsafe.(fun_call (variable "console.log") [| inject x |])

(*
let () =
  let iter =
  Js.Unsafe.set inttbl (Js.string "iter") (Js.Unsafe.eval_string iter)
;;

*)
let create () = Js.Unsafe.obj [||]

let add t ~key ~data = Js.Unsafe.set t key data

let remove t k = Js.Unsafe.delete t k

let find t k =
  if Js.to_bool Js.Unsafe.(meth_call t "hasOwnProperty" [| inject k |])
  then Some (Js.Unsafe.get t k)
  else None
;;

let find_exn t k =
  if Js.to_bool Js.Unsafe.(meth_call t "hasOwnProperty" [| inject k |])
  then Js.Unsafe.get t k
  else raise Not_found
;;


let iter t ~f : unit =
  let js_iter = Js.Unsafe.get inttbl (Js.string "iter") in
  Js.Unsafe.(fun_call js_iter [| inject t; inject (Js.wrap_callback (fun key data -> f ~key ~data)) |])
;;

let fold t ~init ~f =
  let js_fold = Js.Unsafe.get inttbl (Js.string "fold") in
  Js.Unsafe.(fun_call js_fold [| inject t; inject init; inject (Js.wrap_callback (fun x key data -> f x ~key ~data))|])

let map t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> add t' ~key ~data:(f data));
  t'

let filteri t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> if f ~key ~data then add t' ~key ~data);
  t'

let filter t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> if f data then add t' ~key ~data);
  t'

let to_array t =
  let arr = jsnew Js.array_empty () in
  iter t ~f:(fun ~key ~data -> arr##push((key, data)));
  Js.to_array arr

let keys t =
  let arr = jsnew Js.array_empty () in
  iter t ~f:(fun ~key ~data -> arr##push(key));
  Js.to_array arr

let data t =
  let arr = jsnew Js.array_empty () in
  iter t ~f:(fun ~key ~data -> arr##push(data));
  Js.to_array arr

let copy t =
  let t' = create () in
  iter t ~f:(add t');
  t'

let length t =
  let len = ref 0 in
  iter t ~f:(fun ~key:_ ~data:_ -> incr len);
  !len

