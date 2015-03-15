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

let colored = ref true
let powerline = ref false
let utf8 = ref true
let verbose = ref false

let encoding () : Symbols.encoding =
  if !powerline then (module Symbols.Powerline) else
  if !utf8 then (module Symbols.Utf8) else
  (module Symbols.Ascii)

let symbols () : Symbols.symbols =
  let (module E) : Symbols.encoding = encoding () in
  (module Symbols.Symbols(E))
