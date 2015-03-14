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

open Command;;

let lst = ref []

module Cmd : Command =
struct
  let key = "status"
  (* First space needed for help message alignment *)
  let doc = " Show the workspace status"
  let specs = []
  let handle_anon_arg arg = lst := !lst @ [arg]
  let execute () = print_string (String.concat " " !lst); print_endline ""
end