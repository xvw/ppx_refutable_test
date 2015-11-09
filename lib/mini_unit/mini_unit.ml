(* Mini unit is a very small framework for unit-testing.
   This test framework is only for testing ppx_text.
*)


type report = {
  mutable total     : int
; mutable succeeded : int 
}

let report = {
  total     = 0
; succeeded = 0
}

module Assert =
struct

  let flag v = if v then fst else snd
  let print verbose v  =
    let st = ("success", "failure") in 
    if verbose then print_endline ((flag v) st)
      
  let incr_total () = report.total <- succ (report.total)
  let incr_succ  () = report.succeeded <- succ (report.succeeded)

  let exec ?(verbose=true) v=
    let _ = incr_total () in
    let r = if v then (incr_succ (); true) else false in
    let _ = print verbose v in r

  let is_true = exec 
  let is_false ?(verbose=true)      v   = is_true  ~verbose (not v)
  let is_equals ?(verbose=true)     x y = is_true  ~verbose (x = y)
  let is_not_equals ?(verbose=true) x y = is_false ~verbose (x = y)

end

let total     () = report.total
let succeeded () = report.succeeded
let failed    () = report.total - report.succeeded
let report    () =
  Printf.printf
    "\n---\n%s\n---\n[Tests : %d / %d succeeded]"
    (if report.total = report.succeeded then "SUCCESS" else "FAILURE")
    report.succeeded
    report.total
