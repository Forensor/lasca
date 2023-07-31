module Team exposing (Team(..), defaultTeam)

{-| The two sides of the match.

`White` always starts first.

-}


type Team
    = White
    | Black


defaultTeam : Team
defaultTeam =
    White
