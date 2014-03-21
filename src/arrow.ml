let first f = fun (x, y) -> (f x, y)

let second f = fun (x, y) -> (x, f y)

let both f = fun (x, y) -> (f x, f y)

module Infix = struct
  let ( *** ) f g = fun (x, y) -> (f x, g y)

  let (&&&) f g = fun x -> (f x, g x)
end

