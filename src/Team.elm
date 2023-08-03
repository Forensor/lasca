module Team exposing (Team(..), defaultTeam, toString)

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
