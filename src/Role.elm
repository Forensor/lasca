module Role exposing (Role(..))

{-| The role of a given `Counter`.

`Soldier`s can only move forward, but `Officer`s are able to go to any `Direction`.

-}


type Role
    = Soldier
    | Officer
