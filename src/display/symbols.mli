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

(** Symbols provider for different encodings .*)

module type Encoding
(** The possible types of encoding. *)

type encoding = (module Encoding)
(** Shortcut type for Encoding modules *)

module Ascii : Encoding
(** Ascii encoding module. *)

module Utf8 : Encoding
(** UTF8 encoding module. *)

module Powerline : Encoding
(** UTF8 encoding module with powerline glyphs support. *)

module type Symbols =
sig
  val glider : string
  (** Glider symbol *)

  val branch : string
  (** Branch symbol *)
end
(** The Symbols module providing different glyphs and symbols. *)

type symbols = (module Symbols)
(** Shortcut type for Symbols modules *)

module Make :
  functor (E : Encoding) ->
  sig
    val glider : string
    val branch : string
  end
(** Functor defining the Symbols module from an Encoding. *)
