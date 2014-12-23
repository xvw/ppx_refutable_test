(* A little Assert module, only for ppx_test presentation *)
(* Xavier van de Woestyne <xaviervdw@gmail.com> *)

module Assert =
struct

  let total = ref 0
  let successed = ref 0

  let execute ?(verbose=true) v =
    let _ = incr total in
    if v then begin
      let _ = incr successed in
      if verbose then print_string "success"
    end
    else
    if verbose then print_string "fail"

  let isTrue = execute
  let isFalse ?(verbose=true) x = execute ~verbose (not x)
  let isEquals ?(verbose=true) x y = isTrue ~verbose (x = y)
  let isNotEquals ?(verbose=true) x y = isFalse ~verbose (x = y)
    
end

let report () =
  Printf.printf
    "\n[Test status]: %d/%d successed\n"
    !Assert.successed
    !Assert.total
    
