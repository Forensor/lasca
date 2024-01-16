module Team exposing
    ( Team(..)
    , className
    , default
    , opposite
    , toString
    )

{-| Module to handle `Team` related functions.
-}


{-| The two sides of the match.

`White` always starts first.

-}
type Team
    = White
    | Black


default : Team
default =
    White


toString : Team -> String
toString team =
    case team of
        White ->
            "White"

        Black ->
            "Black"


{-| Get the opposite of the passed `Team`.

Works like the `not` function.

-}
opposite : Team -> Team
opposite team =
    case team of
        White ->
            Black

        Black ->
            White



-- All view related stuff is beyond here


{-| CSS _className_ used to handle Events.
-}
className : Team -> String
className team =
    toString team
        |> String.toLower
