(* Let's test sets launchable *)
(* Xavier Van de Woestyne <xaviervdw@gmail.com> *)

open Ast_mapper
open Ast_helper
open Asttypes
open Parsetree
open Longident

(* Location creation *)
let create_loc ?(loc = !default_loc) v = 
  {txt = v; loc = loc}
let loc = create_loc

(* Id creation *)
let create_ident ?(loc = !default_loc) v = 
  create_loc ~loc (Lident v)
let ident = create_ident

(* Generalisation on Pattern var *)
let pattern s = Pat.var (loc s)

(* Error handling *)
let fail ?(loc = !default_loc) message =  
  let open Location in 
  raise (Error (error ~loc message))

(* Create registered reference *)
let ref_test_list =
  let empty = Exp.construct (ident "[]") None in 
  let refc = Exp.record [ident "contents", empty] None in  
  let vb = Vb.mk (pattern "ref_test_list") refc in
  Str.value Nonrecursive [vb]

(* Create tests access *)
let tests_access =
  let str_t   = Typ.constr (ident "string") [] in
  let unit_t  = Typ.constr (ident "unit") [] in
  let unit_f  = Typ.arrow "" unit_t unit_t in 
  let content =
    Exp.field
      (Exp.ident (ident "ref_test_list"))
      (ident "contents")
  in
  let revl    =
    Exp.apply (Exp.ident (ident "rev")) ["", content] in
  let openl   = Exp.open_ Fresh (ident "List") revl in 
  let t_type  = Typ.tuple [str_t; unit_f] in
  let func =
    Exp.fun_ "" None (pattern "()") openl in
  let list_t  = Typ.constr (ident "list") [t_type] in
  let c_type  = Typ.arrow "" unit_t list_t in
  let constr  = Exp.constraint_ func c_type in
  let binding = Vb.mk (pattern "registered_tests") constr in
  Str.value Nonrecursive [binding]

(* Create execution routine *)
let test_execution =
  let apply_f =
    Exp.apply
      (Exp.ident (ident "f"))
      ["", Exp.ident (ident "()")]
  in
  let print =
    Exp.apply
      (Exp.ident (ident "printf"))
      ["", Exp.constant (Const_string ("[%s] ", None));
       "", Exp.ident (ident "label")
      ]
  in
  let openp  = Exp.open_ Fresh (ident "Printf") print in 
  let ifthen =
    Exp.ifthenelse
      (Exp.ident (ident "verbose"))
      (openp)
      None
  in
  let nl =
    Exp.apply
      (Exp.ident (ident "print_endline"))
      ["", (Exp.constant (Const_string ("",None)))]
  in 
  let iterator =
    Exp.fun_
      ""
      None
      (Pat.tuple [pattern "label"; pattern "f"])
      (Exp.sequence ifthen (Exp.sequence apply_f nl))
  in
  let reg =
    Exp.apply
      (Exp.ident (ident "registered_tests"))
      ["", Exp.ident (ident "()")]
  in
  let map =
    Exp.apply
      (Exp.ident (ident "map"))
      ["", iterator; "", reg;]
  in
  let openl   = Exp.open_ Fresh (ident "List") map in
  let func    = Exp.fun_ "" None (pattern "()") openl in
  let subf    =
    Exp.fun_
      "?verbose"
      (Some (Exp.construct (ident "true") None))
      (pattern "verbose")
      func
  in 
  let binding = Vb.mk (pattern "execute_tests") subf
  in Str.value Nonrecursive [binding]

(* Create registered lambda *)
let create_lambda lbl expr =
  let contents =
    Exp.field
      (Exp.ident (ident "ref_test_list"))
      (ident "contents")
  in
  let cons f =
    Exp.construct
      (ident "::")
      (Some (Exp.tuple [f; contents]))
  in
  let lambda = Exp.fun_ "" None (pattern "()") expr in
  Exp.setfield
    (Exp.ident (ident "ref_test_list"))
    (ident "contents")
    (cons (Exp.tuple [lbl; lambda]))

(* Tests substitution *)
let struct_test s =
  match s.pstr_desc with
  | Pstr_attribute ({txt="test_process"; loc=loc}, pl) ->
    begin (* @@@test_process case *)
      match pl with
      | PStr [substr] -> Str.mk (substr.pstr_desc)
      | _ -> fail ~loc "[@@@test_process] Malformed expr"
    end
  | Pstr_attribute ({txt="test_register"; loc=loc}, pl) ->
    begin (*@@@test_register case *)
      match pl with
      | PStr [{pstr_desc = Pstr_eval (e, _);pstr_loc=l}] ->
        begin
          match e.pexp_desc with
          | Pexp_tuple [lbl; expr] ->
            begin (*Valid registration*)
              Str.mk (Pstr_eval (create_lambda lbl expr, []))
            end
          | _ ->
            fail
              ~loc:l"[@@@test_register] Malformed tuple"
        end
      | _ -> fail ~loc "[@@@test_register] Malformed expr"
    end
  | _ -> s 

(* General procedure *)
let map_ast this s =
  let sub = List.map struct_test s in
  (ref_test_list
   :: tests_access
   :: test_execution
   :: sub)

(* Change structure value *)
let test_mapper argv =
  let super = default_mapper in
  { super with structure = map_ast }

(* Register AST *)
let _ = register "test_mapper" test_mapper
