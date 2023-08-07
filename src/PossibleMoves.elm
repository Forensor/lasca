module PossibleMoves exposing (..)

import Capture exposing (Capture)
import CaptureStep exposing (CaptureStep)
import Coord
import Move exposing (Move)
import Set.Any as AnySet exposing (AnySet)


{-| Possible moves the current turn can make.

Either a you are able to make `Moves` or `Captures`, but not both at the same time.

-}
type PossibleMoves
    = Captures (AnySet String CaptureStep)
    | Moves (AnySet String Move)
    | None


default : PossibleMoves
default =
    Moves
        (AnySet.fromList Move.toString
            [ { origin = Coord.S8, destination = Coord.S12 }
            , { origin = Coord.S9, destination = Coord.S12 }
            , { origin = Coord.S9, destination = Coord.S13 }
            , { origin = Coord.S10, destination = Coord.S13 }
            , { origin = Coord.S10, destination = Coord.S14 }
            , { origin = Coord.S11, destination = Coord.S14 }
            ]
        )
