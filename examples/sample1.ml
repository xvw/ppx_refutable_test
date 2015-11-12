(* a Simple example with refutable context *)


(* This text is always displayed *)
let _ = print_endline "Common text"

(* This text is displayed only when the preprocessor is not used *)
let _ = print_endline "Refuted text" [@@refute]

(* this text is used only when the preprocessor is used *)
[@@@process (print_endline "Processed text")]
