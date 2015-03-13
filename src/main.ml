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

open Command;;

(* Reference to the command passed as argument *)
let cmd : command option ref = ref None

(* Transform a command into a Arg.spec definition *)
let cmd_to_spec (module Cmd : Command) =
  (Cmd.key, Arg.Set (ref false), Cmd.doc)

(* The list of commands available *)
let cmds_list : command list = [
  (module Cmd_init.Cmd);
  (module Cmd_status.Cmd);
]

(* Construct the list of commands' specifications *)
let cmds_spec = Arg.align @@ List.map cmd_to_spec cmds_list

(* Reference to the current arguments spec *)
let spec = ref cmds_spec

(* Change the context regarding to the command *)
let switch_cmd arg = 
  if !Arg.current = 1 then
    begin
      let rec find_cmd cmds : command = match cmds with
        | [] -> raise @@ Arg.Bad (arg ^ " is not a recognized subcommand")
        | (module Cmd : Command) :: xs -> if arg = Cmd.key then (module Cmd) else find_cmd xs in
      let (module Cmd) = find_cmd cmds_list in
      cmd := Some (module Cmd);
      spec := Arg.align @@ Cmd.spec;
    end
  else match !cmd with
  | Some (module Cmd) -> Cmd.anon_arg arg
  | None -> raise @@ Arg.Bad (arg ^ " is not a recognized parameters")

(* Execute the selected command *)
let run_cmd () = match !cmd with
  | Some (module Cmd) -> Cmd.execute ()
  | None -> raise @@ Arg.Bad "Internal Error"

(* Main function, run the application *)
let main () =
  let description = "hws, A workspace manager for hackers." in
  Arg.parse_dynamic spec switch_cmd description;
  run_cmd ()

(* Execute the main function, except when launched from the toplevel *)
let () = if not !Sys.interactive then main ()
