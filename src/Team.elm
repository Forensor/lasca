module Team exposing
    ( Team(..)
    , className
    , defaultTeam
    , opposite
    , toString
    )

{-| The two sides of the match.

`White` always starts first.

-}


type Team
    = White
    | Black


defaultTeam : Team
defaultTeam =
    White


toString : Team -> String
toString team =
    case team of
        White ->
            "White"

        Black ->
            "Black"


className : Team -> String
className team =
    toString team
        |> String.toLower


opposite : Team -> Team
opposite team =
    case team of
        White ->
            Black

        Black ->
            White
