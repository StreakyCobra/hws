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

let key = "debug"

(* First space needed for help message alignment *)
let doc = " Show informations about the workspace"

let specs = []

let handle_anon_arg arg =
  let errmsg = "'" ^ arg ^ "' argument not supported" in
  raise @@ Arg.Bad errmsg

let handle_rest_arg arg =
  let errmsg = "'" ^ arg ^ "' argument not supported" in
  raise @@ Arg.Bad errmsg

type content =
  | File of string
  | Folder of string

let paths () = [
  "Current directory  " , Folder !Config.original_dir;
  "Workspace root     " , Folder !Config.workspace_root;
  "Workspace directory" , Folder !Config.workspace_dir;
  "Configuration file " , File   !Config.config_file;
  "Projects file      " , File   !Config.projects_file;
  "Ignore file        " , File   !Config.ignore_file;
]

let display_content (title, item) =
  let (module R) = !Config.render in
  let verb = !Config.verbose in
  let path = match item with
    | File path -> path
    | Folder path -> path in
  let exists = Sys.file_exists path in
  let color = if exists
      then Ansi.Green
      else Ansi.Yellow in
  print_endline @@ R.content_header ~exp:verb ~color:color ~pre:title path;
  if verb then
    begin
      let func = match item with
      | File _ -> R.file_content
      | Folder _ -> R.dir_content in
      if exists then print_endline @@ func ~color:color path;
      print_endline @@ R.content_closer ~color:color ();
      print_endline ""
    end

let execute () =
  List.iter display_content @@ paths ()
