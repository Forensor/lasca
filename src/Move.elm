module Move exposing (Move, soundFilename, toString)

import Coord exposing (Coord)


type alias Move =
    { origin : Coord
    , destination : Coord
    }


{-| Converts a `Move` to a
[_Standard Algebraic Notation_](https://en.wikipedia.org/wiki/Algebraic_notation_(chess))
`String`.

Example:

```
toString { origin = Coord.S1, destination = Coord.S5 }
    -- -> "1-5"
```

-}
toString : Move -> String
toString { origin, destination } =
    List.map (Coord.toString >> String.dropLeft 1) [ origin, destination ]
        |> String.join "-"


soundFilename : String
soundFilename =
    "move.mp3"
