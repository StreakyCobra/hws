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

(* Flags *)
let colored           = Ansi.enabled
let powerline         = ref false
let utf8              = ref true
let verbose           = ref false
let render : Render.render ref = 
  let (module D) : Display.display = (module Display.Utf8) in
  let (module R) : Render.render = (module Render.Make (D)) in
  ref ((module R) : Render.render)

(* Constants *)
let workspace_dirname = ".hws"
let config_filename   = "config"
let projects_filename = "projects"
let ignore_filename   = "ignore"

(* Paths *)
let original_dir      = ref ""
let workspace_root    = ref ""
let workspace_dir     = ref ""
let config_file       = ref ""
let projects_file     = ref ""
let ignore_file       = ref ""

(* Select encoding according to flags *)
let select_display () =
  let (module D) : Display.display = if !powerline then
    (module Display.Powerline)
  else if !utf8 then
    (module Display.Utf8)
  else
    (module Display.Ascii) in
  let (module R) : Render.render = (module Render.Make (D)) in
  render := ((module R) : Render.render)

let prepare_paths () =
  original_dir   := Sys.getcwd ();
  workspace_root := Workspace.workspace_root workspace_dirname;
  workspace_dir  := Filename.concat !workspace_root workspace_dirname;
  let config_relative filename = Filename.concat !workspace_dir filename in
  config_file    := config_relative config_filename;
  projects_file  := config_relative projects_filename;
  ignore_file    := config_relative ignore_filename

let read_config () = ()

let init () =
  select_display ();
  prepare_paths ()
