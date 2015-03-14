module type Command =
sig
  val key : string
  val doc : string
  val specs : (Arg.key * Arg.spec * Arg.doc) list
  val handle_anon_arg : string -> unit
  val handle_rest_arg : string -> unit
  val execute : unit -> unit
end

type command = (module Command)

(* Transform a command into a Arg.spec definition *)
let cmd_to_specs (module Cmd : Command) =
  (Ansi.format [Ansi.red] Cmd.key , Arg.Set (ref false), Cmd.doc)
