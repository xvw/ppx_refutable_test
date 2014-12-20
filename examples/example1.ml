(* Example of ppx_test usage*)

module Essay =
  struct 
    let succ x = x + 1
    let pred x = x - 1
    let is_null x = (x = 0)
    let divisible_by2 x = (x mod 2) = 1
  end

    [@@@test_register
     let x = 9 in assert(9 = x) in
     let y = 10 in assert(10 = x)
    ]





				    
