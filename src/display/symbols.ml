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

type encoding_flags =
  | None
  | Ascii
  | Utf8
  | Powerline

module type Encoding = sig val t : encoding_flags end
type encoding = (module Encoding)

(* Modules corresponding to encoding_flags *)
module None      : Encoding = struct let t = None      end
module Ascii     : Encoding = struct let t = Ascii     end 
module Utf8      : Encoding = struct let t = Utf8      end
module Powerline : Encoding = struct let t = Powerline end

module Default =
struct
  let rec glider = function
    | None             -> ""
    | Ascii            -> "..:"
    | Utf8 | Powerline -> "⠠⠵"
  let rec branch = function
    | None             -> ""
    | Ascii | Utf8     -> "Y"
    | Powerline        -> ""
  let rec line = function
    | None             -> ""
    | Ascii | Utf8     -> "L"
    | Powerline        -> ""
  let rec hold = function
    | None             -> ""
    | Ascii | Utf8     -> "H"
    | Powerline        -> ""
  let rec right_plain = function
    | None             -> ""
    | Ascii | Utf8     -> ">"
    | Powerline        -> ""
  let rec right = function
    | None             -> ""
    | Ascii | Utf8     -> ">"
    | Powerline        -> ""
  let rec left_plain = function
    | None             -> ""
    | Ascii | Utf8     -> "<"
    | Powerline        -> ""
end

module type Symbols =
sig
  val glider :string
  val branch :string
  val line :string
  val hold :string
  val right_plain :string
  val right :string
  val left_plain :string
end

type symbols = (module Symbols)

module Make (E : Encoding) =
struct
  let glider = Default.glider E.t
  let branch = Default.branch E.t
  let line = Default.line E.t
  let hold = Default.hold E.t
  let right_plain = Default.right_plain E.t
  let right = Default.right E.t
  let left_plain = Default.left_plain E.t
end
