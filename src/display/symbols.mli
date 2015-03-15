module type Encoding
type encoding = (module Encoding)
module Ascii : Encoding
module Utf8 : Encoding
module Powerline : Encoding
module type Symbols = sig val glider : string val branch : string end
type symbols = (module Symbols)
module Symbols :
  functor (E : Encoding) -> sig val glider : string val branch : string end
