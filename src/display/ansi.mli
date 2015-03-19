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

(** ANSI escape codes and facilites. *)

val enabled : bool ref
(** Boolean reference to enable/disable colored output. *)

val tty     : bool ref
(** Boolean reference to change the TTY mode to true/false, what
    enables/disables colored output. *)

type color =
  | Black 
  | Red 
  | Green 
  | Yellow 
  | Blue 
  | Magenta 
  | Cyan 
  | White

type style =
  | Reset
  | Bold
  | Underline
  | Blink
  | Inverse
  | Foreground of color
  | Background of color
  | IntensiveForeground of color
  | IntensiveBackground of color

type command =
  | LineUp of int
  | LineDown of int
  | Up of int
  | Down of int
  | Right of int
  | Left of int
  | ClearScreen
  | ClearLine
  | MvFirstColumn

val black         : style
val red           : style
val green         : style
val yellow        : style
val blue          : style
val magenta       : style
val cyan          : style
val white         : style
val on_black      : style
val on_red        : style
val on_green      : style
val on_yellow     : style
val on_blue       : style
val on_magenta    : style
val on_cyan       : style
val on_white      : style
val hi_black      : style
val hi_red        : style
val hi_green      : style
val hi_yellow     : style
val hi_blue       : style
val hi_magenta    : style
val hi_cyan       : style
val hi_white      : style
val on_hi_black   : style
val on_hi_red     : style
val on_hi_green   : style
val on_hi_yellow  : style
val on_hi_blue    : style
val on_hi_magenta : style
val on_hi_cyan    : style
val on_hi_white   : style

val invert        : style -> style
(** Return the inversed color. E.g. white returns on_white *)
  
val complement    : color -> color
(** Return the complement of the color, to maximize contrast between foreground
and background. *)
  
val reline        : command list
(** Sequence of commands to rewrite current line *)    

val set_styles    : style list -> unit
(** Helper to set the styles of what will be printed afterward. *)

val reset_styles  : unit -> unit
(** Helper to reset the terminal appearance to its default. *)

val format        : style list -> string -> string
(** Format a string with the given styles and return it. *)

val print         : style list -> string -> unit
(** Helper to print a text with the given list of styles applied before, and
    reseted after. *)

val print_nl      : style list -> string -> unit
(** Helper to print a text with the given list of styles applied before, and
    reseted after. Append a newline at the end of the string. *)

val exec_cmds     : command list -> unit
(** Helper to execute a given list of commands. *)
