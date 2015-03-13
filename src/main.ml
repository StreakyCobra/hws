(* Copyright (C) 2015  Fabien Dubosson
 *
 * This file is part of hws.
 *
 * hws is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * hws is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with hws.  If not, see <http://www.gnu.org/licenses/>. *)

(* The list of commands. *)
let cmds_list : (module Command.Cmd) list = [
  (module Cmd_init.Cmd);
  (module Cmd_status.Cmd)
]

(* Transform a command into a spec for the Arg module. *)
let cmd_to_spec (module Cmd : Command.Cmd) =
  (Cmd.key, Arg.Unit (fun () -> ()), Cmd.desc)

(* Change the context regarding to the command. *)
let cmds_change arg = 
  if arg = Cmd_init.Cmd.key then Cmd_init.Cmd.execute ()
  else if arg = Cmd_status.Cmd.key then Cmd_status.Cmd.execute ()
  else raise @@ Arg.Bad (arg ^ " is not a recognized argument")

(* Construct the list of commands' specifications. *)
let cmds_spec = ref @@ List.map cmd_to_spec cmds_list

(* Main function. *)
let main () =
  let desc = "TODO: The hws description" in
  Arg.parse_dynamic cmds_spec cmds_change desc

(* Make it execute, except when lunch from toplevel. *)
let () = if not !Sys.interactive then main ()
