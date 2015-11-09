(** {1 Assertions module} *)

(** Assert provide a small API for unit test. *)
(** Each succeeded tests returns true, each failed test returns false *)
module Assert :
sig

  (** {2 Tester} *)
  
  val is_true       : ?verbose:bool -> bool -> bool
  val is_false      : ?verbose:bool -> bool -> bool
  val is_equals     : ?verbose:bool -> 'a -> 'a -> bool
  val is_not_equals : ?verbose:bool -> 'a -> 'a -> bool

end

(** {1 Reporting} *)

(** Returns the total of passed tests *)
val total : unit -> int

(** Returns the total of succeeded tests *)
val succeeded : unit -> int

(** Returns the total of failed tests *)
val failed : unit -> int

(** Display a small report on stdout *)
val report : unit -> unit
