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

(* Reference to the selected command *)
let cmd : command option ref = ref None

(* Reference to the current specifications list *)
let specs = ref []

(* The list of commands available *)
let cmds_list : command list = [
  (module Command.Make(Cmd_init));
  (module Command.Make(Cmd_status));
  (module Command.Make(Cmd_version));
]

(* Construct the list of commands' specifications *)
let cmds_specs () =
  let get_spec (module Cmd : Command) = Cmd.to_spec in
  List.map get_spec cmds_list

(* Ensure one command is selected. If no command has been selected, use the
   default one *)
let ensure_cmd () = match !cmd with
  | None -> cmd := Some (module Command.Make(Cmd_status))
  | Some _ -> ()

(* Handle the rest arguments, after the "--" *)
let handle_rest_arg arg =
  ensure_cmd ();
  match !cmd with
  | None -> failwith "Internal Error"
  | Some (module Cmd) -> Cmd.handle_rest_arg arg

(* General specifications *)
let general_specs () = [
  ("-v"        , Arg.Set Config.verbose  , " Enable verbose output");
  ("-p"        , Arg.Set Config.powerline, " Enable powerline glyph");
  ("--noutf8"  , Arg.Clear Config.utf8   , " Disable utf8 symbols");
  ("--nocolor" , Arg.Clear Config.colored, " Disable colored output");
  ("--"        , Arg.Rest handle_rest_arg, " Rest of arguments");
]

(* Select a command from the string argument given *)
let select_cmd arg =
  let rec find_cmd cmds : command = match cmds with
    | [] -> raise @@ Arg.Bad ("'" ^ arg ^ "' is not a recognized subcommand")
    | (module Cmd : Command) :: xs -> if arg = Cmd.key then (module Cmd) else find_cmd xs in
  let (module Cmd) = find_cmd cmds_list in
  cmd := Some (module Cmd);
  specs := Arg.align (Cmd.specs @ general_specs ())

(* Handle anonymous arguments. If a command is already selected, give it the
argument. Otherwise use this argument to select the subcommand. *)
let handle_anon_arg arg = match !cmd with
  | None -> select_cmd arg
  | Some (module Cmd) -> Cmd.handle_anon_arg arg

(* Execute the selected command *)
let run_cmd () = 
  ensure_cmd ();
  match !cmd with
  | None -> failwith "Internal Error"
  | Some (module Cmd) -> Cmd.execute ()

(* Main function, run the application *)
let main () =
  let project = Ansi.format [Ansi.blue; Ansi.Bold] Version.project in
  let description = Ansi.format [Ansi.blue] Version.description in
  let summary = project ^ ", " ^ description in
  specs := Arg.align @@ cmds_specs () @ general_specs ();
  Arg.parse_dynamic specs handle_anon_arg summary;
  run_cmd ()

(* Hack to disable colors soon enough if "--nocolor" flag is given, otherwise
 * help message is always shown in color. *)
let color_hack () =
  if List.exists (fun a -> a = "--nocolor") (Array.to_list Sys.argv) then Config.colored := false

(* Execute the main function, except when launched from the toplevel *)
let () = if not !Sys.interactive then
    begin
      color_hack ();
      try main () with
      | Failure a -> prerr_endline @@ Ansi.format [Ansi.Bold; Ansi.red] "Error: " ^ a
    end
