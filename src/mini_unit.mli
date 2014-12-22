module Assert :
sig
  val count : int ref
  val success_count : int ref
  val output : string -> bool -> unit
  val execute : ?name:string -> bool -> unit
  val isTrue : ?name:string -> bool -> unit
  val isFalse : ?name:string -> bool -> unit
  val isEquals : ?name:string -> 'a -> 'a -> unit
  val isNotEquals : ?name:string -> 'a -> 'a -> unit
  val isSame : ?name:string -> 'a -> 'a -> unit
  val isNotSame : ?name:string -> 'a -> 'a -> unit
end
val report : unit -> unit
