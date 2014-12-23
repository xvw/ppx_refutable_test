[@@@test_process open OUnit]

(* To test *)
let succ x = x + 1
let pred x = x - 1

(* Tests register*)
[@@@test_register "testSucc", assert_equal 10 (succ 9)]
[@@@test_register "testPred", assert_equal 8 (pred 9)]   
(* Test failure *)
[@@@test_register "testFail", assert_equal 9 (succ 9)]

(* Execute *)
[@@@test_process
  let uTests =
    List.map (fun (l,t) -> l>::t ) (registered_tests ())
  in
    run_test_tt
     ~verbose:true
    ("TestSuccAndPred">:::uTests) 
]
