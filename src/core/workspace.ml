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

(* Check if the given listing contains the folder named dirname *)
let rec contains_dir content dirname = match content with
  | [] -> false
  | current :: rest ->
    if current = dirname && Utils.is_directory current then true
    else contains_dir rest dirname

(* Find the workspace root by looking for a folder name by the given argument *)
let rec workspace_root dirname =
  let dir = Sys.getcwd () in
  let content = Array.to_list @@ Sys.readdir dir in
  if dir = "/" then failwith "Not in a workspace";
  if contains_dir content dirname then
    dir
  else
    begin
      Sys.chdir Filename.parent_dir_name;
      workspace_root dirname
    end
