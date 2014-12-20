(* Example of ppx_test usage*)

module Essay =
struct 
  let succ x = x + 1
  let pred x = x - 1
  let is_null x = (x = 0)
  let divisible_by2 x = (x mod 2) = 1
end

[@@@test_register
  assert((Essay.pred 9) == 8)
]
[@@@test_register
  assert(Essay.is_null 0);
  assert(not (Essay.is_null 1))
]
(* Test with value binding*)
[@@@test_register 
  let x = 9 in
  assert((Essay.succ x) = 12) (* this test fail *)
]

(* Run all tests *)
[@@@test_process
  List.map (fun f -> f () ) (registered_tests ())
]






				    
