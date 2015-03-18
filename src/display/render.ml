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

open Display;;
open Symbols;;

module Default =
struct
  let branch t name =
    let (module D) : display = Display.get t in
    let (module S) : symbols = (module Symbols.Make (D)) in
    match t with
    | Powerline -> S.branch ^ name
    | Utf8      -> S.branch ^ name
    | Ascii     -> S.branch ^ name
    | None      -> S.branch ^ name
end

module type Render =
sig
  val display : Display.display
  val branch : string -> string
end

type render = (module Render)

module Make (D : Display.Display) : Render =
struct
  let display : Display.display = (module D)
  let branch = Default.branch D.display_type
end
