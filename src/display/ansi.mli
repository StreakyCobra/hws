(** ANSI escape codes and facilites. *)

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

val reline        : command list
(** Sequence of commands to rewrite current line *)    

val set_tty       : bool -> unit
(** Helper to change the TTY mode to true/false, what enables/disables colored
  * output. *)

val reset_styles  : unit -> unit
(** Helper to reset the terminal appearance to its default. *)

val print         : style list -> string -> unit
(** Helper to print a text with the given list of styles applied before, and
  * reseted after. *)

val print_nl      : style list -> string -> unit
(** Helper to print a text with the given list of styles applied before, and
  * reseted after. Append a newline at the end of the string. *)

val set_styles    : style list -> unit
(** Helper to set the styles of what will be printed afterward. *)

val exec_cmds     : command list -> unit
(** Helper to execute a given list of commands. *)
