# Concurrent Programming with Effect Handlers

- [Tutorial](https://github.com/ocaml-multicore/ocaml-effects-tutorial?tab=readme-ov-file)

# Some Definitions

- ADT: Algebraic Data Type (aka "tagged union" or "variant type")
    - it as a constructor
    - it carries or not some data
    - all constructor returns the same type
```ocaml
type expr =
  | Int of int
  | Bool of bool
```

- ADT with polymorphic variants
    - unless regular ADT constructors can be shared accross diffent types.
    - variants are open, we can extend them wihtout modifying the original
    definition.
```ocaml
type expr =
  [ `Int of int
  | `Bool of bool
  ]
```

- ADT with polymorphic variant type
```ocaml
type 'a vlist =
  [`Nil
  | `Cons of 'a * 'a vlist
  ]
```

- GADT: Generalized Algebraic Data Type
    - it carries a data but also a return value so it returns a different types per constructor
```ocaml
type _ expr =
  | Int: int -> int expr
  | Bool: bool -> bool expr
```
