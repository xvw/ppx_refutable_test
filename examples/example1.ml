[@@@test_register "test1", 
  let x = 9 in assert(x = 9)
]

  [@@@test_register "test2",
   assert(false)
  ]

[@@@test_process
  execute_tests ~verbose:false ()
]
