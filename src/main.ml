open Printf;;

let main () = printf "Hello, World\n"

let () = if not !Sys.interactive then main ()
