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

module type Render =
sig
  val project_summary : unit -> string
  val indent          : string -> string
  val branch          : string -> string
end

type render = (module Render)

module Make (D : Display.Display) : Render =
struct

  let symbols : symbols = (module Symbols.Make (D))

  let project_summary () =
    let project = Ansi.format [Ansi.blue; Ansi.Bold] Version.project in
    let description = Ansi.format [Ansi.blue] Version.description in
    project ^ ", " ^ description

  let indent = (^) "    "

  let branch name =
    let (module S) : symbols = symbols in
    indent @@ format [red] S.branch ^ " " ^ (format [blue; Bold] name)

end

