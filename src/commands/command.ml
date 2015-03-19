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

module type Command_provider =
sig
  val key : string
  val doc : string
  val specs : (Arg.key * Arg.spec * Arg.doc) list
  val handle_anon_arg : string -> unit
  val handle_rest_arg : string -> unit
  val execute : unit -> unit
end

module type Command =
sig
  include Command_provider
  val to_spec : unit -> (Arg.key * Arg.spec * Arg.doc)
end

type command = (module Command)

module Make (Cmd : Command_provider) : Command =
struct
  include Cmd
  let to_spec () = Ansi.format [Ansi.red] Cmd.key, Arg.Set (ref false), Cmd.doc
end
