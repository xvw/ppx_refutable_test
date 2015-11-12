(* a Simple example with refutable context
   Using ppx_refutable_test, "Hello World" will never be displayed
 *)

let _ = (print_endline "Hello World")[@refutable]
