include List

let iter xs ~f = iter f xs

let map xs ~f = map f xs

let filter xs ~f = filter f xs

let rec filter_map xs ~f = match xs with
  | [] -> []
  | x :: xs ->
    match f x with
    | None -> filter_map ~f xs
    | Some y -> x :: filter_map ~f xs
;;

let rec concat_map xs ~f = match xs with
  | [] -> []
  | x :: xs -> f x @ concat_map ~f xs
;;

let rec partition_map xs ~f = match xs with
  | [] -> ([], [])
  | x :: xs ->
    let (ls, rs) = partition_map ~f xs in
    match f x with
    | Either.InL y -> (y :: ls, rs)
    | Either.InR y -> (ls, y :: rs)
;;

let rec partition xs ~f = match xs with
  | []     -> ([], [])
  | x :: xs ->
    let (ts, fs) = partition ~f xs in
    if f x then (x :: ts, fs) else (ts, x :: fs)
;;

