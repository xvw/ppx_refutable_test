(* Let's test sets launchable *)
(* Xavier Van de Woestyne <xaviervdw@funkywork.com> *)

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident


(*
  All of this part could be erased with 
  ppx_tool usage 
  (But I'm in learning context :P)
*)
(* Helpers *)
let loc_none = Location.none

let create_loc ?(loc = loc_none) v = 
  {txt = v; loc = loc}
let loc = create_loc

let create_ident ?(loc = loc_none) v = 
  create_loc ~loc (Lident v)
let ident = create_ident

let expression ?(loc = loc_none) ?(attributes = []) desc = 
  {
    pexp_desc = desc; 
    pexp_loc  = loc; 
    pexp_attributes = attributes;
  }

let pattern str = {
  ppat_desc = Ppat_var (create_loc str);
  ppat_loc = Location.none; 
  ppat_attributes = []
}

let structure_item ?(loc = loc_none) desc = 
  {
    pstr_desc = desc; 
    pstr_loc = loc;
  }

let value_binding ?(loc = loc_none) ?(attributes = []) p e = 
  {
    pvb_pat = p; 
    pvb_expr = e; 
    pvb_loc = loc;
    pvb_attributes = attributes; 
  }

let define_type ?(loc = loc_none) ?(attributes = []) desc = 
  {
    ptyp_desc = desc; 
    ptyp_loc = loc; 
    ptyp_attributes = attributes;
  }

let empty_list = 
  expression (Pexp_construct (ident "[]", None))

let tuple exprs =
  expression (Pexp_tuple exprs)
	     
let ref' data = 
  expression 
    (Pexp_record ([ident "contents", data], None))

let raw_id s =  
  expression (Pexp_ident (ident s))

let field e f = 
  expression (Pexp_field (raw_id e, ident f))

let unit_type = 
  define_type (Ptyp_constr (ident "unit", []))

let fun' args e =
  let f = Pexp_fun ("", None, args, e)
  in expression f
  

(*
   PREPROCESSOR PROCESS
   Intersting part
*)

		
(* Error handling *)
let fail ?(loc = loc_none) message =  
  let open Location in 
  raise (Error (error ~loc message))

(* Create ref for registered tests*)
let test_list_record =
  let binding = 
    value_binding (pattern "ref_test_list") (ref' empty_list)
  in structure_item (Pstr_value (Nonrecursive, [binding]))
	
(* Create list of registered test*)
let test_list_access =
  let contents = field "ref_test_list" "contents" in
  let f = fun' (pattern "()") contents in
  let unit_fun =
    define_type (Ptyp_arrow ("", unit_type, unit_type)) in
  let t_list =
    define_type (Ptyp_constr (ident "list", [unit_fun])) in
  let t = define_type (Ptyp_arrow ("", unit_type, t_list)) in
  let constr =
    expression (Pexp_constraint (f, t)) in
  let binding =
    value_binding (pattern "registered_tests") constr
  in structure_item (Pstr_value (Nonrecursive, [binding]))

(* Create Cons for the registered tests*)
let cons_reg f =
  let contents = field "ref_test_list" "contents" in
  let cons = 
    Pexp_construct (ident "::", Some (tuple [f; contents]))
  in expression cons

(* Extract an expression from a structure item *)
let extract_expression = function 
  | Pstr_eval (o, a) -> o 
  | _ -> fail "[extract_expression] malformed test"

(* Extract test_data as an expression *)
let list_binding st= 
  let f =
    fun'
      (pattern "()")
      (extract_expression st.pstr_desc)
  in
  let cons = cons_reg f in 
  let e =
    expression 
      (Pexp_setfield
	 (raw_id "ref_test_list", ident "contents", cons)
      )
  in value_binding (pattern "_") e

(* Process to the tests 'substitution *)
let struct_test struct_item = 
  match struct_item.pstr_desc with
  | Pstr_attribute ({txt="test_process";loc=loc}, payload) -> 
     begin 
       (* Process test case *)
       match payload with 
       | PStr [st] -> structure_item ~loc st.pstr_desc
       | _ -> fail ~loc "[@@@test_process] malformed test"
     end
  | Pstr_attribute ({txt="test_register";loc=loc}, payload) ->
     (* register test in a fun () *)
     begin 
       match payload with
       | PStr s ->
	  structure_item
	    (Pstr_value (
		 Nonrecursive,
		 List.map (fun x -> list_binding x) s
	       )
	    )
       | _ -> fail ~loc "[@@@test_registered] malformed test"
     end
  | _ -> struct_item

(* Substitute tests *)
let test_init this s =
  let subl = List.map struct_test s in 
  (test_list_record :: test_list_access :: subl)

(* Map AST*)
let test_mapper argv = 
  let super = default_mapper in
  { super with structure = test_init}

(* Register AST *)
let _ = register "test_mapper" test_mapper

