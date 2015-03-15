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

(** The configuration manager of the application. *)

val colored : bool ref
(** Boolean reference to enable/disable colored output. Enabled by default. *)

val verbose : bool ref
(** Boolean reference to enable/disable verbose output. Disabled by default. *)

val powerline : bool ref
(** Boolean reference to enable/disable use of powerline glyphs. Disabled by
    default. *)

val utf8 : bool ref
(** Boolean reference to enable/disable use of utf8 symbols. Enabled by
    default. *)

val config_folder : string
(** The name of the configuration folder in the hws workspace. *)

val original_dir : string
(** The path to original directory where the program was launched. *)

val workspace_root : string
(** The path to workspace root. *)

val workspace_dir : string
(** The path to workspace directory. *)

val symbols : unit -> Symbols.symbols
(** Return the current Symbols module by looking at utf8 and powerline flags. *)

val read_config : unit -> unit
(** Read and interpret the configuration file. *)
