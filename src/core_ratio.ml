type t = int * int

let rec gcd a b =
  if b = 0 then a else gcd b (a mod b)

module Infix = struct
  (* The negative value is always the denominator *)
  let (%) p q = let d = gcd p q in (p / d, q / d)

  let (+%) (a, b) (c, d) = (a * d + c * b) % (b * d)

  let (-%) t (c, d) = t +% (-c, d)

  let ( *% ) (a, b) (c, d) = (a * c) % (b * d)

  let (/%) t (c, d) = t *% (d, c)

  let (>%) t1 t2 = let (p, q) = t1 -% t2 in p > 0 && q > 0
  let (<%) t1 t2 = t2 >% t1

  let (>=%) t1 t2 = t1 = t2 || t1 >% t2
  let (<=%) t1 t2 = t1 = t2 || t1 <% t2
end

let numerator (a, _)   = a
let denominator (_, b) = b

let to_pair t = t

let to_float (a, b) = float_of_int a /. float_of_int b

