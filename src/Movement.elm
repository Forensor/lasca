module Movement exposing (Movement(..), toString)

import Capture exposing (Capture)
import Move exposing (Move)


{-| Type to wrap the two possible types of `Movement`.

Although `Move`s and `Capture`s are different, they're still both `Movement`s.

-}
type Movement
    = Capture Capture
    | Move Move


toString : Movement -> String
toString movement =
    case movement of
        Capture capture ->
            Capture.toString capture

        Move move ->
            Move.toString move
