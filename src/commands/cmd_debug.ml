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
let doc = " Show informations about this workspace"

let specs = []

let handle_anon_arg arg = raise @@ Arg.Bad ("'" ^ arg ^ "' argument not supported")

let handle_rest_arg arg = raise @@ Arg.Bad ("'" ^ arg ^ "' argument not supported")

let print_exists filename =
  let color = if Sys.file_exists filename then Ansi.green else Ansi.yellow in
  Ansi.print_nl [color] filename

let execute () =
  Ansi.print [Ansi.Bold] "Current directory:   ";
  print_exists !Config.original_dir;
  Ansi.print [Ansi.Bold] "Workspace root:      ";
  print_exists !Config.workspace_root;
  Ansi.print [Ansi.Bold] "Workspace directory: ";
  print_exists !Config.workspace_dir;
  Ansi.print [Ansi.Bold] "Configuration file:  ";
  print_exists !Config.config_file;
  Ansi.print [Ansi.Bold] "Projects file:       ";
  print_exists !Config.projects_file;
  Ansi.print [Ansi.Bold] "Ignore file:         ";
  print_exists !Config.ignore_file
