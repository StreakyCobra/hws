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

(** The command module for defining subcommand of the application. *)

module type Command_provider =
sig
  val key             : string
  (** The name of the command. *)

  val doc             : string
  (** The description of the command. *)

  val specs           : (Arg.key * Arg.spec * Arg.doc) list
  (** The specification of the command. *)

  val handle_anon_arg : string -> unit
  (** A function handling the anonymous arguments. *)

  val handle_rest_arg : string -> unit
  (** A function handling the rest arguments. *)

  val execute         : unit -> unit
  (** Run the command. *)
end
(** The provider type module for defining the interface to use for modules
    internally. *)
      
module type Command =
sig
  include Command_provider
  (** Include Command_provider content. *)

  val to_spec : unit -> (Arg.key * Arg.spec * Arg.doc)
  (** Return the specification of the command. *)
end
(** The Command type module defining the interface to use for modules. *)

type command = (module Command)
(** Shortcut type for refering to Command modules. *)

module Make : functor (Cmd : Command_provider) -> Command
(** Construct a Command from its provider representation. *)
