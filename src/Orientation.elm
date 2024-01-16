module Orientation exposing (..)

{-| Which side of the board is facing you.

Default `Orientation` is `Whiteside`.

-}


type Orientation
    = Whiteside
    | Blackside


default : Orientation
default =
    Whiteside
