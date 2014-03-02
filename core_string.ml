include String

let concat ?(sep="") ts = concat sep ts

let concat_array ?(sep="") ts =
  Js.to_string ((Js.array ts)##join(Js.string sep))

