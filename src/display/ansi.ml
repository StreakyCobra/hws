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

open Printf;;

(* ANSI color type *)
type color =
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White

(* ANSI style type *)
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

(* ANSI command type *)
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

(* Sequence control *)
let csi     = "\027["
let css     = ";"
let sgr_end = "m"
let nl      = "\n"

(* Normal foreground colors *)
let black         = Foreground Black
let red           = Foreground Red
let green         = Foreground Green
let yellow        = Foreground Yellow
let blue          = Foreground Blue
let magenta       = Foreground Magenta
let cyan          = Foreground Cyan
let white         = Foreground White

(* Normal background colors *)
let on_black      = Background Black
let on_red        = Background Red
let on_green      = Background Green
let on_yellow     = Background Yellow
let on_blue       = Background Blue
let on_magenta    = Background Magenta
let on_cyan       = Background Cyan
let on_white      = Background White

(* Intensive foreground colors *)
let hi_black      = IntensiveForeground Black
let hi_red        = IntensiveForeground Red
let hi_green      = IntensiveForeground Green
let hi_yellow     = IntensiveForeground Yellow
let hi_blue       = IntensiveForeground Blue
let hi_magenta    = IntensiveForeground Magenta
let hi_cyan       = IntensiveForeground Cyan
let hi_white      = IntensiveForeground White

(* Intensive background colors *)
let on_hi_black   = IntensiveBackground Black
let on_hi_red     = IntensiveBackground Red
let on_hi_green   = IntensiveBackground Green
let on_hi_yellow  = IntensiveBackground Yellow
let on_hi_blue    = IntensiveBackground Blue
let on_hi_magenta = IntensiveBackground Magenta
let on_hi_cyan    = IntensiveBackground Cyan
let on_hi_white   = IntensiveBackground White

(* Sequences helpers *)
let reline = [ClearLine; MvFirstColumn]

(* Type to code conversion *)
let color_code = function
  | Black   -> 0
  | Red     -> 1
  | Green   -> 2
  | Yellow  -> 3
  | Blue    -> 4
  | Magenta -> 5
  | Cyan    -> 6
  | White   -> 7

let sgr_code = function
  | Reset                   -> 0
  | Bold                    -> 1
  | Underline               -> 4
  | Blink                   -> 5
  | Inverse                 -> 7
  | Foreground col          -> 30 + (color_code col)
  | Background col          -> 40 + (color_code col)
  | IntensiveForeground col -> 90 + (color_code col)
  | IntensiveBackground col -> 100 + (color_code col)

let ansi_code = function
  | LineUp n    -> string_of_int n ^ "F"
  | LineDown n  -> string_of_int n ^ "E"
  | Up n        -> string_of_int n ^ "A"
  | Down n      -> string_of_int n ^ "B"
  | Right n     -> string_of_int n ^ "C"
  | Left n      -> string_of_int n ^ "D"
  | ClearScreen -> "2J"
  | ClearLine   -> "2K"
  | MvFirstColumn  -> "0G"

let rec sgr styles =
  let beg = if styles = [] then "" else csi in
  let rec sgr' styles = match styles with
    | []    -> ""
    | x::[] -> string_of_int (sgr_code x) ^ sgr_end
    | x::xs -> string_of_int (sgr_code x) ^ css ^ (sgr' xs)
  in
  beg ^ sgr' styles

let rec ansi cmds =
  let beg = if cmds = [] then "" else csi in
  beg ^ match cmds with
  | []    -> ""
  | x::[] -> ansi_code x
  | x::xs -> ansi_code x ^ css ^ ansi xs

(* TTY handling *)
let tty = ref @@ Unix.isatty Unix.stdout

(* Printing helpers *)
let set_styles styles =
  let esc_code = if !tty then sgr styles else "" in
  printf "%s" esc_code

let reset_styles () =
  set_styles [Reset]

let format styles text =
  let styles_code = if !tty then sgr styles else "" in
  let reset_code = if !tty then sgr [Reset] else "" in
  styles_code ^ text ^ reset_code
  
let print styles text =
  set_styles styles;
  printf "%s" text;
  reset_styles ()

let print_nl styles text =
  print styles @@ text ^ nl

let exec_cmds cmds =
  let esc_code = if !tty then ansi cmds else "" in
  printf "%s" esc_code
