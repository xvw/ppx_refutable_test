(* Mini Unit is a micro collection of Assert functions *)
(* Only for ppx_test presentation *)

module Assert =
struct

  let count = ref 0
  let success_count = ref 0 

  let output label success =
    let trace =
      if success
      then begin
        let _ = incr success_count in 
        "successed"
      end
      else "failed"
    in Printf.printf "[%d:%s] \t %s \n" !count label trace
      
  let execute ?(name="Classic execute") x =
    let _ = incr count in
    output name x

  let isTrue ?(name="Is true ?") x =
    execute ~name x
      
  let isFalse ?(name="Is false ?") x =
    execute ~name (not x)

  let isEquals ?(name="Is equals ?") x y =
    isTrue ~name (x = y)

  let isNotEquals ?(name = "Is not equals ?") x y =
    isFalse ~name (x = y)

  let isSame ?(name = "Is the same ?") x y =
    isTrue ~name (x == y)

  let isNotSame ?(name = "Is not the same ?") x y =
    isFalse ~name (x == y)
  
end

let report () =
  Printf.printf
    "\n[%d/%d] tests successed\n"
    !Assert.success_count
    !Assert.count
