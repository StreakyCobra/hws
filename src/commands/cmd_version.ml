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

open Ansi;;

let display_normal () =
  let (module R) = !Config.render in
  print_nl [] @@ R.project_summary ();
  print [] "Version: ";
  print_nl [Bold; red] Version.str

let display_verbose () =
  display_normal ();
  print [] "Name:    ";
  print_nl [red] Version.name
    
let display_version () = match !Config.verbose with
  | false -> display_normal ()
  | true -> display_verbose ()

let key = "version"

(* First space needed for help message alignment *)
let doc = " Display the version number"

let specs = []

let handle_anon_arg arg =
  let errmsg = "'" ^ arg ^ "' argument not supported" in
  raise @@ Arg.Bad errmsg

let handle_rest_arg arg =
  let errmsg = "'" ^ arg ^ "' argument not supported" in
  raise @@ Arg.Bad errmsg

let execute () = display_version ()
