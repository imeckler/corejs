include String

let concat ?(sep="") ts = concat sep ts

let concat_array ?(sep="") ts =
  Js.to_string ((Js.array ts)##join(Js.string sep))

let init n ~f =
  if n < 0 then failwith (Printf.sprintf "String.init %d < 0" n);
  let t = create n in
  for i = 0 to n - 1 do
    t.[i] <- f i;
  done;
  t
;;
