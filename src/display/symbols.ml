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

module Default =
struct
  let glider = function
    | None             -> ""
    | Ascii            -> ""
    | Utf8 | Powerline -> "⠠⠵"
  let branch = function
    | None             -> ""
    | Ascii | Utf8     -> ""
    | Powerline        -> ""
  let line = function
    | None             -> ""
    | Ascii | Utf8     -> ""
    | Powerline        -> ""
  let hold = function
    | None             -> ""
    | Ascii | Utf8     -> "H"
    | Powerline        -> ""
  let right_plain = function
    | None             -> ""
    | Ascii | Utf8     -> ":"
    | Powerline        -> ""
  let right = function
    | None             -> ""
    | Ascii | Utf8     -> ":"
    | Powerline        -> ""
  let left_plain = function
    | None             -> ""
    | Ascii | Utf8     -> "<"
    | Powerline        -> ""
  let check = function
    | None             -> ""
    | Ascii            -> "[x]"
    | Utf8 | Powerline -> "✔"
  let nocheck = function
    | None             -> ""
    | Ascii            -> "[ ]"
    | Utf8 | Powerline -> "✘"
end

module type Symbols =
sig
  val display : Display.display
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

module Make (E : Display) =
struct
  let display : Display.display = (module E)
  let glider = Default.glider E.display_type
  let branch = Default.branch E.display_type
  let line = Default.line E.display_type
  let hold = Default.hold E.display_type
  let right_plain = Default.right_plain E.display_type
  let right = Default.right E.display_type
  let left_plain = Default.left_plain E.display_type
  let check = Default.check E.display_type
  let nocheck = Default.nocheck E.display_type
end
