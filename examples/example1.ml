[@@@test_process open Mini_unit ]

let succ x = x + 1
let pred x = x - 1

[@@@test_register "test_succ",
    let x = 9 in
       Assert.isEquals (succ x) 10
]

[@@@test_register "test_pred",
    let x = 9 in
       Assert.isEquals (pred x) 8
]

(* Test qui va échouer *)
[@@@test_register "test_qui_echoue",
    let x = 9 in
       Assert.isNotEquals (succ x) 10
]

(* un dernier tests pour la route *)
[@@@test_register "un_dernier_test",
    Assert.isNotEquals 10 11
]

(* Lancement des tests *)
[@@@test_process
  let _ = execute_tests () in report ()
]
