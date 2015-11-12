(* 
 * A small preprocessor for inline test environement 
 *
 * Copyright (c) 2015 Xavier Van de Woestyne <xaviervdw@gmail.com>
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *)


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
  | Pstr_value (flag, vb) ->
    not (List.exists (fun v ->List.exists refute v.pvb_attributes) vb)
  | Pstr_primitive vd ->
    not (List.exists refute vd.pval_attributes)
  | Pstr_type td ->
    not (List.exists (fun v ->List.exists refute v.ptype_attributes) td)
  | Pstr_typext te ->
    not (List.exists refute te.ptyext_attributes)
  | Pstr_exception e ->
    not (List.exists refute e.pext_attributes)
  | Pstr_module mb ->
    not (List.exists refute mb.pmb_attributes)
  | Pstr_recmodule mb ->
    not (List.exists (fun v ->List.exists refute v.pmb_attributes) mb)
  | Pstr_modtype md ->
    not (List.exists refute md.pmtd_attributes)
  | Pstr_open od ->
    not (List.exists refute od.popen_attributes)
  | Pstr_class cl ->
    not (List.exists (fun v ->List.exists refute v.pci_attributes) cl)
  | Pstr_class_type cl ->
    not (List.exists (fun v ->List.exists refute v.pci_attributes) cl)
  | Pstr_include inc ->
    not (List.exists refute inc.pincl_attributes)
  | _ -> true

(* Transform attributes into executable code fragment *)
let rec transform_attr s =
  match s.pstr_desc with
  (* [@@@process ... ] founded *)
  | Pstr_attribute ({txt="process"; loc=loc}, payload) ->
    begin
      match payload with
      | PStr [substr] -> Str.mk (substr.pstr_desc)
      | _ -> Helper.fail ~loc "[@@@process ...] Malformed structure"
    end
  (* Analysis for Modules *)
  | Pstr_module ({
      pmb_name = _
    ; pmb_expr = mod_expr
    ; pmb_attributes = _
    ; pmb_loc = _
    } as desc) -> reconstitute_module s desc mod_expr
  (* Normal expression *)
  | _ -> s

(* Preprocess module expression *)
and preprocess_module mod_expr = {
  mod_expr with
  pmod_desc = 
    match mod_expr.pmod_desc with
    | Pmod_structure str -> Pmod_structure (purge_and_swap str)
    | Pmod_functor (sl, mt, me) ->
      let r = preprocess_module me in
      Pmod_functor (sl, mt, r)
    | x -> x
}
    
(* Reconstitute a module with transformation *)
and reconstitute_module s desc mod_expr =
  {
    s with
    pstr_desc =
      Pstr_module {
        desc with pmb_expr = preprocess_module mod_expr
      }
  }
  

and purge_and_swap s =
  List.filter remove_refutables s 
  |> List.map transform_attr

(* Transform process/register attributes *)
and remap_ast _ s = purge_and_swap s 

(* General Mapper *)
let mapper argv = 
  let super = default_mapper in
  {
    super with
    structure = remap_ast
  } 

(* Register preprocessor *)
let () = register "refutable_test" mapper
