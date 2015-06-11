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

type display_type =
  | Ascii
  | Utf8
  | Powerline

module type Display =
sig
  val display_type : display_type
end

type display = (module Display)

module Ascii     : Display = struct let display_type = Ascii     end
module Utf8      : Display = struct let display_type = Utf8      end
module Powerline : Display = struct let display_type = Powerline end

let get : display_type -> display = function
  | Ascii     -> (module Ascii)
  | Utf8      -> (module Utf8)
  | Powerline -> (module Powerline)
