module CaptureStep exposing (CaptureStep, soundFilename, toString)

import Coord exposing (Coord)


{-| A `CaptureStep` is a single action of moving a `Piece` to a single destination adding
the topmost `Counter` of the captured `Piece` to yours. It does not care about the rest of
possible further `CaptureStep`s.
-}
type alias CaptureStep =
    { origin : Coord
    , capturee : Coord
    , destination : Coord
    }


{-| Converts a `CaptureStep` to a
[_Standard Algebraic Notation_](https://en.wikipedia.org/wiki/Algebraic_notation_(chess))
`String`.

Example:

```
toString { origin = Coord.S1, capturee = Coord.S5, destination = Coord.S9 }
    -- -> "1-5-9"
```

-}
toString : CaptureStep -> String
toString { origin, capturee, destination } =
    List.map (Coord.toString >> String.dropLeft 1) [ origin, capturee, destination ]
        |> String.join "-"


soundFilename : String
soundFilename =
    "capture.mp3"
