module Capture exposing (Capture, toString)

import CaptureStep exposing (CaptureStep)
import Coord exposing (Coord)
import List.NonEmpty exposing (NonEmpty)


{-| A `Capture` holds the whole record of `CaptureStep`s a capturing action can make.
-}
type alias Capture =
    NonEmpty CaptureStep


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
toString ( firstCaptureStep, rest ) =
    CaptureStep.toString firstCaptureStep
        ++ (List.map
                (CaptureStep.toString
                    >> String.split "-"
                    >> List.drop 1
                    >> String.join "-"
                )
                rest
                |> String.join "-"
           )
