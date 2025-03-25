(* [sum_up acc] read a string until we read ctrl-D that is EOF.
   It convert the string to an int and add it to the accumulator.
   When EOF is read an exception is generated.
   It also raises an exception if it fails to convert the string
   to int.
 *)
let rec sum_up acc =
  let l = input_line stdin in
  acc := !acc + int_of_string l;
  sum_up acc

let () =
  let r = ref 0 in
  try sum_up r
  with End_of_file ->  Printf.printf "Sum is %d\n" !r
