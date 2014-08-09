module String = StringLabels

let capitalize = String.capitalize
let concat ?(sep="") l = String.concat ~sep l
let copy = String.copy
let escaped = String.escaped
let fill = String.fill
let index_exn = String.index
let index_from_exn = String.index_from
let lowercase = String.lowercase
let make = String.make
let rindex_exn = String.rindex
let rindex_from_exn = String.rindex_from
let uncapitalize = String.uncapitalize
let uppercase = String.uppercase
let length = String.length
let sub = String.sub
let create = String.create

let index t char =
  try Some (index_exn t char)
  with Not_found -> None

let rindex t char =
  try Some (rindex_exn t char)
  with Not_found -> None

let index_from t pos char =
  try Some (index_from_exn t pos char)
  with Not_found -> None

let rindex_from t pos char =
  try Some (rindex_from_exn t pos char)
  with Not_found -> None

let lsplit2_exn line ~on:delim =
  let pos = StringLabels.index line delim in
    (sub line ~pos:0 ~len:pos,
    sub line ~pos:(pos+1) ~len:(String.length line - pos - 1)
    )

let rsplit2_exn line ~on:delim =
  let pos = StringLabels.rindex line delim in
  (sub line ~pos:0 ~len:pos,
   sub line ~pos:(pos+1) ~len:(String.length line - pos - 1)
  )

let lsplit2 line ~on =
  try Some (lsplit2_exn line ~on) with Not_found -> None

let rsplit2 line ~on =
  try Some (rsplit2_exn line ~on) with Not_found -> None

let rec char_list_mem l (c:char) =
  match l with
  | [] -> false
  | hd::tl -> hd = c || char_list_mem tl c

let split_gen str ~on =
  let is_delim =
    match on with
    | `char c' -> (fun c -> c = c')
    | `char_list l -> (fun c -> char_list_mem l c)
  in
  let len = String.length str in
  let rec loop acc last_pos pos =
    if pos = -1 then
      sub str ~pos:0 ~len:last_pos :: acc
    else
      if is_delim str.[pos] then
        let pos1 = pos + 1 in
        let sub_str = sub str ~pos:pos1 ~len:(last_pos - pos1) in
        loop (sub_str :: acc) pos (pos - 1)
    else loop acc last_pos (pos - 1)
  in
  loop [] len (len - 1)
;;

let split str ~on = split_gen str ~on:(`char on) ;;

let split_on_chars str ~on:chars =
  split_gen str ~on:(`char_list chars)
;;

let split_lines =
  let back_up_at_newline ~t ~pos ~eol =
    pos := !pos - (if !pos > 0 && t.[!pos - 1] = '\r' then 2 else 1);
    eol := !pos + 1;
  in
  fun t ->
    let n = length t in
    if n = 0
    then [||]
    else
      (* Invariant: [-1 <= pos < eol]. *)
      let pos = ref (n - 1) in
      let eol = ref n in
      let ac = [||] in
      (* We treat the end of the string specially, because if the string ends with a
         newline, we don't want an extra empty string at the end of the output. *)
      if t.[!pos] = '\n' then back_up_at_newline ~t ~pos ~eol;
      while !pos >= 0 do
        if t.[!pos] <> '\n'
        then decr pos
        else
          (* Becuase [pos < eol], we know that [start <= eol]. *)
          let start = !pos + 1 in
          Core_array.push (sub t ~pos:start ~len:(!eol - start)) ac;
          back_up_at_newline ~t ~pos ~eol
      done;
      Core_array.push (sub t ~pos:0 ~len:!eol) ac;
      Core_array.rev_inplace ac;
      ac
;;

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

