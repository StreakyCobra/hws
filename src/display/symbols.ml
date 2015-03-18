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

module type Symbols =
sig
  val display : display
  val glider : string
  val branch : string
  val line : string
  val hold : string
  val right_plain : string
  val right : string
  val left_plain : string
  val check : string
  val nocheck : string
end

type symbols = (module Symbols)

module Make (D : Display) =
struct
  let display : display = (module D)
  let glider = match D.display_type with
    | None             -> ""
    | Ascii            -> ""
    | Utf8 | Powerline -> "⠠⠵"
  let branch = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> ""
    | Powerline        -> ""
  let line = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> ""
    | Powerline        -> ""
  let hold = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> "H"
    | Powerline        -> ""
  let right_plain = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> ":"
    | Powerline        -> ""
  let right = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> ":"
    | Powerline        -> ""
  let left_plain = match D.display_type with
    | None             -> ""
    | Ascii | Utf8     -> "<"
    | Powerline        -> ""
  let check = match D.display_type with
    | None             -> ""
    | Ascii            -> "[x]"
    | Utf8 | Powerline -> "✔"
  let nocheck = match D.display_type with
    | None             -> ""
    | Ascii            -> "[ ]"
    | Utf8 | Powerline -> "✘"
end
