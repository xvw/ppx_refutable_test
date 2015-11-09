(* Test for mini_unit *)
open Mini_unit

exception Fail

let attempt v = Printf.printf "[Attempted : %s] " v

let test_is_true () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_true true) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_true false); raise Fail with
    | Assert_failure _ -> ()
  in () 

let test_is_false () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_false false) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_false true); raise Fail with
    | Assert_failure _ -> ()
  in ()

let test_is_equals () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_equals 10 10) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_equals 0 7); raise Fail with
    | Assert_failure _ -> ()
  in ()


let test_is_not_equals () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_not_equals 10 1) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_not_equals 7 7); raise Fail with
    | Assert_failure _ -> ()
  in ()

let test_counter () =
  let _ = assert (total() == 8) in
  let _ = assert (succeeded() == 4) in
  assert (failed() == 4)


let _ =
  try 
    test_is_true       ();
    test_is_false      ();
    test_is_equals     ();
    test_is_not_equals ();
    test_counter       ();
    print_endline "Everything seems oké"
  with _ -> print_endline "An error occured"
