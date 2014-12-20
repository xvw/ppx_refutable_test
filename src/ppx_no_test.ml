(* Clean all components with test annotation *)
(* Xavier Van de Woestyne <xaviervdw@funkywork.com> *)

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

(* clean all test annotation *)
let clean_floating_test this s =
  let has_test x =
    match x.pstr_desc with
    | Pstr_attribute ({txt="test_register";_},_) 
    | Pstr_attribute ({txt="test_process";_},_) -> false
    | _ -> true
  in default_mapper.structure this (List.filter has_test s)

let mapper argv = 
  let super = default_mapper in 
  {super with structure = clean_floating_test}

let _ = register "test" mapper
