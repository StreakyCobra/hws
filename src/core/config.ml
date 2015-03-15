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

let colored = Ansi.enabled
let powerline = ref false
let utf8 = ref true
let verbose = ref false

(* Caching modules *)
let symbols_cache : Symbols.symbols option ref = ref None

let encoding () : Symbols.encoding =
  if !powerline then
    (module Symbols.Powerline)
  else if !utf8 then
    (module Symbols.Utf8)
  else
    (module Symbols.Ascii)

let symbols () : Symbols.symbols = match !symbols_cache with
  | None -> (* Module not created, create and cache it *)
    begin
      (* Load module *)
      let (module E) : Symbols.encoding = encoding () in
      let (module S) : Symbols.symbols = (module Symbols.Make(E)) in
      (* Cache it *)
      symbols_cache := Some (module S);
      (* Return it *)
      (module S)
    end
  | Some s -> s (* Module existing, use it *)

let read_config () = ()
