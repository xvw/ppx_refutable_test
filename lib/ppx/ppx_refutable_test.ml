(* test *)

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident


(* provide usefull and reccurent functions *)
module Helper =
struct

  let create_loc ?(loc = !default_loc) v = 
    {txt = v; loc = loc}
  let loc = create_loc
    
  let create_ident ?(loc = !default_loc) v = 
    create_loc ~loc (Lident v)
  let ident = create_ident
    
  let true_ = Exp.construct (ident "true") None
  let removed_expression = Exp.assert_ true_
      
    
end

let is_refutable (loc, _) = loc.txt = "refutable"
let rewrite super mapper expr =
  let attributes = expr.pexp_attributes in
  let new_expr =
    if List.exists is_refutable attributes
    then Helper.removed_expression
    else expr
  in 
  super.expr mapper new_expr

let mapper argv = 
  let super = default_mapper in 
  {super with expr = rewrite super}

let () = register "refutable_test" mapper
