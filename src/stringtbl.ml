type 'a t = { obj : unit Js.t; dummy : 'a ref option }
(* The dummy is there to trigger the value restriction *)

let create () : 'a t = {obj = Js.Unsafe.obj [||]; dummy = None}

let find {obj;dummy} key : 'a option = Js.Optdef.to_option (Js.Unsafe.get obj (Js.string key))

let add {obj;dummy} ~key ~data = Js.Unsafe.set obj (Js.string key) data

let remove {obj;dummy} k = Js.Unsafe.delete obj (Js.string k)

let stringtbl = Js.Unsafe.obj [|
  "iter", Js.Unsafe.eval_string "(function(t,f){for(var k in t){if(t.hasOwnProperty(k)){f(k,t[k]);}}})";
  "fold", Js.Unsafe.eval_string "(function(t, x0, f){for(var k in t){if(t.hasOwnProperty(k)){x0=f(k,t[k],x0);}} return x0;})"
|]

let iter : 'a. 'a t -> f:(key:string -> data:'a -> unit) -> unit =
  fun {obj;dummy} ~f ->
    let js_iter = Js.Unsafe.get stringtbl (Js.string "iter") in
    let js_f = Js.wrap_callback (fun key data -> f ~key:(Js.to_string key) ~data) in
    Js.Unsafe.(fun_call js_iter [|inject obj; inject js_f|])

let fold : 'a 'b . 'a t -> init:'b -> f:(key:string -> data:'a -> 'b -> 'b) -> 'b =
  fun {obj;dummy} ~init ~f ->
    let js_fold = Js.Unsafe.get stringtbl (Js.string "fold") in
    let js_f = Js.wrap_callback (fun key data x0 -> f ~key:(Js.to_string key) ~data x0) in
    Js.Unsafe.(fun_call js_fold [|inject obj; inject init; inject js_f|])

let copy t =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> add t' ~key ~data);
  t'

let length t = fold t ~init:0 ~f:(fun ~key:_ ~data:_ acc -> 1 + acc)

let mem t k = match find t k with Some _ -> true | None -> false

let mapi t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> add t' ~key ~data:(f ~key ~data));
  t'

let map t ~f = mapi t ~f:(fun ~key:_ ~data -> f data)

let filteri t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> if f ~key ~data then add t' ~key ~data);
  t'

let filter t ~f = filteri t ~f:(fun ~key ~data -> f data)

let filter_mapi t ~f =
  let t' = create () in
  iter t ~f:(fun ~key ~data -> match f ~key ~data with
    | None -> ()
    | Some y -> add t' ~key ~data:y);
  t'

let filter_map t ~f = filter_mapi t ~f:(fun ~key ~data -> f data)

