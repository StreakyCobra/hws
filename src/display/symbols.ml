type encoding_flags =
  | Ascii
  | Utf8
  | Powerline

module type Encoding =
sig
  val t : encoding_flags
end

type encoding = (module Encoding)

module Ascii : Encoding =
struct
  let t = Ascii
end

module Utf8 : Encoding =
struct
  let t = Utf8
end

module Powerline : Encoding =
struct
  let t = Powerline
end

module Default =
struct
  let rec glider = function
    | Ascii      -> "..:"
    | Utf8     ->  "⠠⠵"
    | Powerline -> glider Utf8
  let rec branch = function
    | Ascii     -> "Y"
    | Utf8      -> "ᛘ"
    | Powerline -> ""
end

module type Symbols =
sig
  val glider : string
  val branch : string
end

type symbols = (module Symbols)

module Symbols (E : Encoding) : Symbols =
struct
  let glider = Default.glider E.t
  let branch = Default.branch E.t
end
