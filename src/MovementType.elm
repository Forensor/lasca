module MovementType exposing (..)

import Capture exposing (Capture)
import Move exposing (Move)


type MovementType
    = Capture Capture
    | Move Move
