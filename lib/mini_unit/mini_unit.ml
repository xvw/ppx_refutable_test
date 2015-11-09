(* 
 * An extra light framework for unit test (this tool is only for ppx_test 
 * improvement !) 
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
