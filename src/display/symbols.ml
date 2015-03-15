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
  | Ascii
  | Utf8
  | Powerline

module type Encoding =
sig
  val t : encoding_flags
end

type encoding = (module Encoding)

module Ascii : Encoding =
struct
  let t = Ascii
end

module Utf8 : Encoding =
struct
  let t = Utf8
end

module Powerline : Encoding =
struct
  let t = Powerline
end

module Default =
struct
  let rec glider = function
    | Ascii      -> "..:"
    | Utf8     ->  "⠠⠵"
    | Powerline -> glider Utf8
  let rec branch = function
    | Ascii     -> "Y"
    | Utf8      -> "ᛘ"
    | Powerline -> ""
end

module type Symbols =
sig
  val glider : string
  val branch : string
end

type symbols = (module Symbols)

module Make (E : Encoding) : Symbols =
struct
  let glider = Default.glider E.t
  let branch = Default.branch E.t
end
