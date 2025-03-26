(* Instead of the exception we define an Algebraic effect *)
(*exception Conversion_failure of string*)
type _ Effect.t += Conversion_failure : string -> int Effect.t

(* [int_of_string str] convert the string into an integer or raise
   We replaced the exception Conversion_failure by an effect. The
   effect is performed with `perform`.
  *)
let int_of_string str =
  try int_of_string str
  with Failure _ -> Effect.perform (Conversion_failure str)

(* [sum_up acc] read a string until we read ctrl-D that is EOF.
   It convert the string to an int and add it to the accumulator.
   When EOF is read an exception is generated.
   If it fails to decode the string as an int an effect is performed.
  *)
let rec sum_up acc =
  let l = input_line stdin in
  acc := !acc + int_of_string l;
  sum_up acc

let () =
  Printf.printf "Starting up. Please input:\n%!";
  let r = ref 0 in
  let open Effect.Deep in
  (* match_with runs the computation.*)
  match_with sum_up r
    (* Here we are defining the effect handler that is defined in Effect.Deep. There is also
       Effect.Shallow (we will see that later).
       A handler is a record with three fields
       - effc -> handles the effect performs
       - exnc -> handles the exception
       - retc -> the value handler
       *)
    {
      effc =
        (* The effect is the conversion failure *)
        (fun (type c) (eff : c Effect.t) ->
          match eff with
          | Conversion_failure s ->
              Some
                (* name k is a convention, it is the delimited continuation *)
                (fun (k : (c, _) continuation) ->
                  Printf.fprintf stderr "Conversion failure of \"%s\"\n%!" s;
                  continue k 0)
          | _ -> None);
      (* None means ignore the effect *)
      exnc =
        (* The exception is when ctrl-D is entered and thus EOF is reached. *)
        (function
        | End_of_file -> Printf.printf "Sum is %d\n" !r
        | e -> raise e);
      retc =
        (* The sum_up function doesn't return *)
        (fun _ ->
          failwith
            "Unreachable, sum_up shouldn't return because it ends with EOF \
             exception");
    }
