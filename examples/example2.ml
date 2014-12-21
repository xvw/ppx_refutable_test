(* Small example with mini_unit usage *)

(* Open Mini_unit in test context*)
[@@@test_process open Mini_unit]

let incr_list l = List.map (succ) l
let decr_list l = List.map (pred) l
let sum_list  l = List.fold_left ( + ) 0 l

(* Test definition *)
[@@@test_register
  let raw_list = [1;2;3] in
  let out_list = incr_list raw_list
  in Assert.isEquals
    ~name:"Test of incr_list"
    out_list [2;3;4]
]

[@@@test_register
  let li = [1;2;3]
  in Assert.isEquals
    ~name:"Test of sum_list"
    (sum_list li) 6  
]

(* Test with failure !! *)
[@@@test_register
  Assert.isTrue
    ~name:"Test with fail !!"
    false
]

(* Test execution *)
[@@@test_process
  let _ = execute_tests () in report ()
]
