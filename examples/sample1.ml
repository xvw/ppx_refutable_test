(* a Simple example with refutable context *)


module type TEST =
sig

  val t : int -> int -> int
  
end

module S(F : TEST) =
struct

  let t = F.t
  let tt a b = t (t a b) 10

  [@@@process
    let _ = print_int (F.t 10 10)
  ]

end

module R : TEST =
struct
  let t = ( + )
end

module K = S(R)
