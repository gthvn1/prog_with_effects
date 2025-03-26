(* ADT: the type doesn't change depending of the constructor *)
type expr_adt =
  | AInt of int
  | ABool of bool
  | AAdd of expr_adt * expr_adt
  | AEq of expr_adt * expr_adt

let _x1 = AInt 12 (* It works and its type is expr_adt *)
let _x2 = ABool true (* It works and its type is expr_adt *)

(* We cannot write an evaluation function because it should returns
   either int or bool. And it is not possible with ADT.

let rec eval_adt (expr : expr_adt) : ??? =
  match expr with
  | AInt x -> x
  | ABool b -> b
  | AAdd (x, y) -> eval_adt x + eval_adt y
  | AEq (x, y) -> eval_adt x = eval_adt y

  To evaluate it we should do something like this:
*)

let rec eval_adt (expr : expr_adt) : expr_adt =
  match expr with
  | AInt x -> AInt x
  | ABool b -> ABool b
  | AAdd (x, y) -> (
      match (eval_adt x, eval_adt y) with
      | AInt a, AInt b -> AInt (a + b)
      | _ -> failwith "Type error: expected two integers")
  | AEq (x, y) -> (
      match (eval_adt x, eval_adt y) with
      | AInt a, AInt b -> ABool (a = b)
      | ABool a, ABool b -> ABool (a = b)
      | _ -> failwith "Type error: expected same types")

(* GADT: Each constructor has a different result type *)
type _ expr_gdt =
  | GInt : int -> int expr_gdt
  | GBool : bool -> bool expr_gdt
  | GAdd : int expr_gdt * int expr_gdt -> int expr_gdt
  | GEq : int expr_gdt * int expr_gdt -> bool expr_gdt

let rec eval_gdt (type a) (expr : a expr_gdt) : a =
  match expr with
  | GInt x -> x
  | GBool b -> b
  | GAdd (x, y) -> eval_gdt x + eval_gdt y
  | GEq (x, y) -> eval_gdt x = eval_gdt y

(*let y1 : int expr_gdt = GInt 42*)
let y1 = GInt 42
let hello () = print_endline "I'm toto"
