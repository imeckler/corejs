type 'a t

let inttbl = Js.Unsafe.obj [|
  "iter", Js.Unsafe.eval_string "(function(t, f){for(var k in t){if(t.hasOwnProperty(k)){f(parseInt(k),t[k]);}}})"
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

let iter t ~f =
  let js_iter = Js.Unsafe.get inttbl (Js.string "iter") in
  Js.Unsafe.(fun_call js_iter [| inject t; inject (Js.wrap_callback (fun key data -> f ~key ~data)) |])
;;

let map t ~f =
  let t' = create () in iter t ~f:(fun ~key ~data -> add t' ~key ~data:(f data))

let filteri t ~f =
  let t' = create () in iter t ~f:(fun ~key ~data -> if f ~key ~data then add t' ~key ~data)

let filter t ~f =
  let t' = create () in iter t ~f:(fun ~key ~data -> if f data then add t' ~key ~data)

