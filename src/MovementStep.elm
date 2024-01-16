module MovementStep exposing (..)

import CaptureStep exposing (CaptureStep)
import Move exposing (Move)


type MovementStep
    = Move Move
    | CaptureStep CaptureStep
