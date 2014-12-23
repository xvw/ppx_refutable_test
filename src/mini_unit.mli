module Assert :
  sig
    val isTrue : ?verbose:bool -> bool -> unit
    val isFalse : ?verbose:bool -> bool -> unit
    val isEquals : ?verbose:bool -> 'a -> 'a -> unit
    val isNotEquals : ?verbose:bool -> 'a -> 'a -> unit
  end
val report : unit -> unit
