module Capture exposing (Capture, soundFilename, toString)

import Coord exposing (Coord)


type alias Capture =
    { origin : Coord
    , capturee : Coord
    , destination : Coord
    }


{-| Converts a `Capture` to a
[_Standard Algebraic Notation_](https://en.wikipedia.org/wiki/Algebraic_notation_(chess))
`String`.

Example:

```
toString { origin = Coord.S1, capturee = Coord.S5, destination = Coord.S9 }
    -- -> "1-5-9"
```

-}
toString : Capture -> String
toString { origin, capturee, destination } =
    List.map (Coord.toString >> String.dropLeft 1) [ origin, capturee, destination ]
        |> String.join "-"


soundFilename : String
soundFilename =
    "capture.mp3"
