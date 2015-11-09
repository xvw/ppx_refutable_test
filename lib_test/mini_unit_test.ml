(* 
 * Tests for mini_unit
 * (It is a little bit ugly :v :v)
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

open Mini_unit

exception Fail

let attempt v = Printf.printf "[Attempted : %s] " v

let test_is_true () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_true true) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_true false); raise Fail with
    | Assert_failure _ -> ()
  in () 

let test_is_false () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_false false) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_false true); raise Fail with
    | Assert_failure _ -> ()
  in ()

let test_is_equals () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_equals 10 10) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_equals 0 7); raise Fail with
    | Assert_failure _ -> ()
  in ()


let test_is_not_equals () =
  let _ = attempt "success" in
  let _ = assert (Assert.is_not_equals 10 1) in
  let _ = attempt "failure" in
  let _ =
    try assert (Assert.is_not_equals 7 7); raise Fail with
    | Assert_failure _ -> ()
  in ()

let test_counter () =
  let _ = assert (total() == 8) in
  let _ = assert (succeeded() == 4) in
  assert (failed() == 4)


let _ =
  try 
    test_is_true       ();
    test_is_false      ();
    test_is_equals     ();
    test_is_not_equals ();
    test_counter       ();
    print_endline "Everything seems oké"
  with _ -> print_endline "An error occured"
