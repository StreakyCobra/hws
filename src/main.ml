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

open Subcommand;;

(* Reference to the selected command. *)
let cmd : (module Subcommand) option ref = ref None

(* The list of commands. *)
let cmds_list : (module Subcommand) list = [
  (module Cmd_init.Cmd);
  (module Cmd_status.Cmd)
]

(* Transform a command into a spec for the Arg module. *)
let cmd_to_spec (module Cmd : Subcommand) =
  (Cmd.key, Arg.Unit (fun () -> ()), Cmd.doc)

(* Construct the list of commands' specifications. *)
let cmds_spec = List.map cmd_to_spec cmds_list

let spec = ref cmds_spec

(* Change the context regarding to the command. *)
let cmds_change arg = 
  let rec find_cmd cmds : (module Subcommand)= match cmds with
    | [] -> raise @@ Arg.Bad (arg ^ " is not a recognized subcommand")
    | (module Cmd : Subcommand) :: xs -> if arg = Cmd.key then (module Cmd) else find_cmd xs in
  let (module Cmd) = find_cmd cmds_list in
  cmd := Some (module Cmd);
  spec := Cmd.spec

(* Execute the selected command. *)
let execute_cmd () = match !cmd with
  | Some (module Cmd : Subcommand) -> Cmd.execute ()
  | None -> raise @@ Arg.Bad "Internal Error"

(* Main function. *)
let main () =
  let desc = "TODO: The hws description" in
  Arg.parse_dynamic spec cmds_change desc;
  execute_cmd ()

(* Make it execute, except when lunch from toplevel. *)
let () = if not !Sys.interactive then main ()
