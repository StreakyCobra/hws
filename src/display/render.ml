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
open Display;;
open Symbols;;
open Utils;;

module type Render =
sig
  val indent          : string -> string
  val project_summary : unit -> string
  val branch          : string -> string
  val content_header  : ?exp:bool -> ?color:Ansi.color -> ?pre:string -> string -> string
  val file_content    : ?color:Ansi.color -> string -> string
  val dir_content     : ?color:Ansi.color -> string -> string
  val content_closer  : ?color:Ansi.color -> unit -> string
end

type render = (module Render)

module Make (D : Display.Display) : Render =
struct

  let symbols : symbols = (module Symbols.Make (D))

  let indent = (^) "    "

  let project_summary () =
    let project = Ansi.format [Ansi.blue; Ansi.Bold] Version.project in
    let description = Ansi.format [Ansi.blue] Version.description in
    project ^ ", " ^ description

  let branch name =
    let (module S) : symbols = symbols in
    indent @@ format [red] S.branch ^ " " ^ (format [blue; Bold] name)

  let content_header ?(exp=false) ?(color=White) ?(pre="") filename =
    let (module S) : symbols = symbols in
    let expsym = if exp then S.box_top_left ^ " " else "" in
    let sym = match D.display_type with
      | Ascii | Utf8 ->
        Ansi.format [Background color; black;] ">"
      | Powerline ->
        Ansi.format [Foreground color] S.right_plain
    in
    String.concat "" [
      Ansi.format [Background color; black;] @@
      expsym ^ pre ^ " "; sym ^ " " ^ filename]

  let file_content ?(color=White) filename =
    let (module S) : symbols = symbols in
    let content = read_file filename in
    let c_indent path =
      begin
        Ansi.format [Background color; black;] S.box_vertical ^ " " ^ path
      end
    in String.concat "\n" @@ List.map c_indent content

  let dir_content ?(color=White) dirname =
    let (module S) : symbols = symbols in
    let relative = Filename.concat dirname in
    let content = List.sort compare @@ Array.to_list @@ Sys.readdir dirname in
    let c_indent path =
      begin
        let tpe = if Utils.is_directory @@ relative path
          then Ansi.format [blue] " d "
          else Ansi.format [red] " - " in
      Ansi.format [Background color; black;] S.box_vertical ^ tpe ^ path
      end in
    String.concat "\n" @@ List.map c_indent content

  let content_closer ?(color=White) () =
    let (module S) : symbols = symbols in
    Ansi.format [Background color; black;] S.box_bottom_left

end

