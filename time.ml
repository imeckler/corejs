type t = float

let now () = Js.to_float ((jsnew Js.date_now ())##valueOf())

let (-) = (-.)

let (+) = (+.)

let to_ms t = t

module Span = struct
  type t = float

  let to_ms t = t

  let of_ms t = t

  let (+) = (+.)

  let (-) = (-.)

  let (/) = (/.)
end

let to_string = string_of_float

(*
module Infix = struct
  let (-) x y = x - y
end

*)
