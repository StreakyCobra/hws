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
  val display : display
  val branch : string -> string
end

type render = (module Render)

module Make (D : Display.Display) : Render =
struct
  let display : display = (module D)
  let branch name =
    let (module S) : symbols = (module Symbols.Make (D)) in
    format [red] S.branch ^ " " ^ (format [blue; Bold] name)
end

