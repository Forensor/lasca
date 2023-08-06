module Preferences exposing (Preferences, default)

{-| User preferences for custom configuration.

Most of them come from flags through app initialization.

-}

import Orientation exposing (Orientation)
import Piece


{-| User `Preferences` for the application.
-}
type alias Preferences =
    { pieceSize : Float
    , orientation : Orientation
    }


default : Preferences
default =
    { pieceSize = Piece.defaultSize
    , orientation = Orientation.default
    }
