module Movement exposing (Movement(..))

import Capture exposing (Capture)
import Move exposing (Move)


{-| Type to wrap the two possible types of `Movement`.

Although `Move`s and `Capture`s are different, they're still both `Movement`s.

-}
type Movement
    = Capture Capture
    | Move Move
