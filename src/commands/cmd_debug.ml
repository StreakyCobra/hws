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

type content =
  | File of string * string
  | Folder of string * string

let paths () = [
  Folder ("Current directory" , !Config.original_dir);
  Folder ("Workspace root" , !Config.workspace_root);
  Folder ("Workspace directory" , !Config.workspace_dir);
  File   ("Configuration file" , !Config.config_file);
  File   ("Projects file" , !Config.projects_file);
  File   ("Ignore file" , !Config.ignore_file);
]

(* Max length of the title to print *)
let title_maxlength =
  (* Get max length of a list with a fold *)
  let maxlen = List.fold_left (fun a b -> max a @@ String.length b) 0 in
  (* function to get only the title of File and Folder entries *)
  let title = function | Folder (t,_) -> t | File (t, _) -> t in
  (* Get max length of the titles of the paths *)
  maxlen @@ List.map (title) @@ paths ()

(* Return the spacing missing for a title to have all aligned *)
let spacing title =
  (* Length of the missing space *)
  let diff = title_maxlength - (String.length title) in
  (* Create the spacing *)
  let result = ref "" in
  for i = 0 to diff do
    result := !result ^ " "
  done;
  (* Return it *)
  !result

let print_exists ?(long=false) title filename =
  let (module S) = Config.symbols () in
  let exist_sym = if Sys.file_exists filename then S.check else S.nocheck in
  let oncolor, color = if Sys.file_exists filename then
      (Ansi.on_green, Ansi.green)
    else
      (Ansi.on_yellow, Ansi.yellow) in
  if long then
    begin
      Ansi.print [Ansi.black; oncolor] title;
      Ansi.print [color] S.right_plain
    end
  else
    begin
      Ansi.print [] title;
      Ansi.print [] ":";
    end;
  Ansi.print [] @@ spacing title;
  Ansi.print [color] @@ " " ^ exist_sym ^ " " ;
  Ansi.print_nl [color] filename

let read_file filename =
  let lines = ref [] in
  let ic = open_in filename in
  try
    while true;
    do
      lines := input_line ic :: !lines
    done; []
  with
  | End_of_file -> close_in ic; List.rev !lines
  | e -> close_in_noerr ic; raise e


let print_content filename = if Sys.file_exists filename then
    begin
      let content = read_file filename in
      let print_indent path =
        begin
          Ansi.print [Ansi.on_green] " ";
          print_endline @@ " " ^ path
        end in
      List.iter (print_indent) content;
    end;
  print_endline ""

let print_listing dirname =
  let relative name = Filename.concat dirname name in
  let content = Array.to_list @@ Sys.readdir dirname in
  let print_indent path =
    begin
      Ansi.print [Ansi.on_green] " ";
      print_string @@ if Sys.is_directory (relative path) then " d " else " - ";
      print_endline path
    end in
  List.iter (print_indent) content;
  print_endline ""

let display_content ?(verbose=false) = function
  | File (title, path) ->
    print_exists ~long:!Config.verbose title path;
    if verbose then print_content path
  | Folder (title, path) ->
    print_exists ~long:!Config.verbose title path;
    if verbose then print_listing path

let execute () = List.iter (display_content ~verbose:!Config.verbose) @@ paths ()
