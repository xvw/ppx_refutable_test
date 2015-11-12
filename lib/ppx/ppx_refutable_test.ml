(* test *)

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident


(* provide usefull and reccurent functions.
   Pre-saved expressions and structs
*)
module Helper =
struct
  
  let fail ?(loc = !default_loc) message =  
    let open Location in 
    raise (Error (error ~loc message))
      
  let create_loc ?(loc = !default_loc) v =  {txt = v; loc = loc}
  let create_ident ?(loc = !default_loc) v = create_loc ~loc (Lident v)
  let true_ = Exp.construct (create_ident "true") None
  let removed_expression = Exp.assert_ true_ 
    
end

(* Check if an expression is refutable *)
(* A refutable node is a node who is erased at the compile time, 
 * if it has [@refutable] attribute.
*)
let refute (loc, _) = loc.txt = "refute"

let remove_refutables s =
  match s.pstr_desc with
  | Pstr_eval (expr, attributes) ->
    not (List.exists refute attributes)
  | _ -> true

(* Transform attributes into executable code fragment *)
let transform_attr s =
  match s.pstr_desc with
  (* [@@@process ... ] founded *)
  | Pstr_attribute ({txt="process"; loc=loc}, payload) ->
    begin
      match payload with
      | PStr [substr] -> Str.mk (substr.pstr_desc)
      | _ -> Helper.fail ~loc "[@@@process ...] Malformed structure"
    end
  (* Normal expression *)
  | _ -> s

(* Transform process/register attributes *)
let remap_ast this s =
  List.filter remove_refutables s 
  |> List.map transform_attr

(* General Mapper *)
let mapper argv = 
  let super = default_mapper in
  {
    super with
    structure = remap_ast
  } 

(* Register preprocessor *)
let () = register "refutable_test" mapper
