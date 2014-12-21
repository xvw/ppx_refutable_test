ppx_test
========
Provide a refutable testing context for OCaml, using **ppx**.

## Introduction
`ppx_test` add anotation to define tests set. For example :

```ocaml
[@@@test_process
  let x = 9 in assert(x = 9)
]
```
Will be ignored at compile time. If the `-ppx ppx test.negative` is used, this snippet will be substituted by :
```ocaml
let _ =
  let x = 9
  in assert(x = 9)
  ```

