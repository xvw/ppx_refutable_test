(* Micro sample  
 * Without ppx_refutable_test, all fragment enclosed into [@@@process ... ]
 * will be ignored. 
 * With ppx_refutable_test, all block labelized with [@@refute] will be 
 * ignored.
 *)

let is_adult x =
  if x <= 0 then `Not_born
  else if x < 18 then `Young
  else `Ok

[@@@process
  let test =
    let _ = assert ((is_adult (-3)) = `Not_born) in
    let _ = assert ((is_adult 17) = `Young) in
    assert ((is_adult 26) = `Ok)
]

let _ =
  let _ = print_endline "This application containes SEXUAL CONTENT" in
  let _ = print_endline "What's your age?\n" in
  let age = read_int () in
  match is_adult age with
  | `Not_born -> print_endline "God ! You 'are not born !"
  | `Young -> print_endline "You're so young !"
  | `Ok -> print_endline "Welcome on this securised application...\nSEX"
[@@refute]

module Test = struct

end


[@@@process
   print_endline "All tests are done"
]
