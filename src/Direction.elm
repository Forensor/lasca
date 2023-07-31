module Direction exposing (Direction(..), allDirections, toString)

import Set.Any as AnySet exposing (AnySet)


{-| `Direction`s where `Piece`s can go.

`UpLeft` means `↖`, `UpRight` means `↗`, and so on...

-}
type Direction
    = UpLeft
    | UpRight
    | DownLeft
    | DownRight


allDirections : AnySet String Direction
allDirections =
    AnySet.fromList toString
        [ UpLeft
        , UpRight
        , DownLeft
        , DownRight
        ]


toString : Direction -> String
toString direction =
    case direction of
        UpLeft ->
            "UpLeft"

        UpRight ->
            "UpRight"

        DownLeft ->
            "DownLeft"

        DownRight ->
            "DownRight"
