module Board exposing (..)

import Dict exposing (Dict)
import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Html)
import Html.Attributes as Attrs
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Svg
import Svg.Attributes as SvgAttrs


type Coord
    = S1
    | S2
    | S3
    | S4
    | S5
    | S6
    | S7
    | S8
    | S9
    | S10
    | S11
    | S12
    | S13
    | S14
    | S15
    | S16
    | S17
    | S18
    | S19
    | S20
    | S21
    | S22
    | S23
    | S24
    | S25


type alias Board =
    AnyDict String Coord Piece


coordToString : Coord -> String
coordToString coord =
    case coord of
        S1 ->
            "S1"

        S2 ->
            "S2"

        S3 ->
            "S3"

        S4 ->
            "S4"

        S5 ->
            "S5"

        S6 ->
            "S6"

        S7 ->
            "S7"

        S8 ->
            "S8"

        S9 ->
            "S9"

        S10 ->
            "S10"

        S11 ->
            "S11"

        S12 ->
            "S12"

        S13 ->
            "S13"

        S14 ->
            "S14"

        S15 ->
            "S15"

        S16 ->
            "S16"

        S17 ->
            "S17"

        S18 ->
            "S18"

        S19 ->
            "S19"

        S20 ->
            "S20"

        S21 ->
            "S21"

        S22 ->
            "S22"

        S23 ->
            "S23"

        S24 ->
            "S24"

        S25 ->
            "S25"


view : Board -> Html msg
view board =
    Html.div
        [ Attrs.class "w-[490px] h-[490px] bg-board bg-no-repeat bg-cover relative" ]
        (board
            |> AnyDict.toList
            |> List.map
                (\( coord, piece ) ->
                    viewPiece coord piece
                )
        )


viewPiece : Coord -> Piece -> Html msg
viewPiece coord piece =
    let
        { top, left } =
            getBoardPositionByCoord coord
    in
    Html.div
        [ Attrs.class "piece w-[70px] h-[70px] absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromInt top ++ "px;"
                , "left: " ++ String.fromInt left ++ "px;"
                ]
        , Attrs.id <| coordToString coord
        ]
        (piece
            |> NonEmpty.indexedMap
                (\index counter ->
                    let
                        {- We need to invert indices since topmost `Counter` is the head
                           of the `NonEmpty`
                        -}
                        position : Int
                        position =
                            (NonEmpty.length piece - 1) - index
                    in
                    viewCounter { position = position } counter
                )
            |> NonEmpty.toList
        )


type Team
    = White
    | Black


type Role
    = Soldier
    | Officer


type alias Counter =
    { team : Team
    , role : Role
    }


type alias Piece =
    NonEmpty Counter


getCounterHexColors : Counter -> { stroke : String, fill : String }
getCounterHexColors { team, role } =
    case ( team, role ) of
        ( White, Soldier ) ->
            { stroke = "#B8B8B8", fill = "#E5E5E5" }

        ( Black, Soldier ) ->
            { stroke = "#0A0A0A", fill = "#363636" }

        ( White, Officer ) ->
            { stroke = "#025033", fill = "#04AA6D" }

        ( Black, Officer ) ->
            { stroke = "#822121", fill = "#CD3C3C" }


getBoardPositionByCoord : Coord -> { top : Int, left : Int }
getBoardPositionByCoord coord =
    case coord of
        S1 ->
            { top = 420, left = 0 }

        S2 ->
            { top = 420, left = 140 }

        S3 ->
            { top = 420, left = 280 }

        S4 ->
            { top = 420, left = 420 }

        S5 ->
            { top = 350, left = 70 }

        S6 ->
            { top = 350, left = 210 }

        S7 ->
            { top = 350, left = 350 }

        S8 ->
            { top = 280, left = 0 }

        S9 ->
            { top = 280, left = 140 }

        S10 ->
            { top = 280, left = 280 }

        S11 ->
            { top = 280, left = 420 }

        S12 ->
            { top = 210, left = 70 }

        S13 ->
            { top = 210, left = 210 }

        S14 ->
            { top = 210, left = 350 }

        S15 ->
            { top = 140, left = 0 }

        S16 ->
            { top = 140, left = 140 }

        S17 ->
            { top = 140, left = 280 }

        S18 ->
            { top = 140, left = 420 }

        S19 ->
            { top = 70, left = 70 }

        S20 ->
            { top = 70, left = 210 }

        S21 ->
            { top = 70, left = 350 }

        S22 ->
            { top = 0, left = 0 }

        S23 ->
            { top = 0, left = 140 }

        S24 ->
            { top = 0, left = 280 }

        S25 ->
            { top = 0, left = 420 }


defaultBoard : Board
defaultBoard =
    AnyDict.fromList coordToString
        [ ( S1, ( { team = White, role = Soldier }, [] ) )
        , ( S2, ( { team = White, role = Soldier }, [] ) )
        , ( S3, ( { team = White, role = Soldier }, [] ) )
        , ( S4, ( { team = White, role = Soldier }, [] ) )
        , ( S5, ( { team = White, role = Soldier }, [] ) )
        , ( S6, ( { team = White, role = Soldier }, [] ) )
        , ( S7, ( { team = White, role = Soldier }, [] ) )
        , ( S8, ( { team = White, role = Soldier }, [] ) )
        , ( S9, ( { team = White, role = Soldier }, [] ) )
        , ( S10, ( { team = White, role = Soldier }, [] ) )
        , ( S11, ( { team = White, role = Soldier }, [] ) )
        , ( S15, ( { team = Black, role = Soldier }, [] ) )
        , ( S16, ( { team = Black, role = Soldier }, [] ) )
        , ( S17, ( { team = Black, role = Soldier }, [] ) )
        , ( S18, ( { team = Black, role = Soldier }, [] ) )
        , ( S19, ( { team = Black, role = Soldier }, [] ) )
        , ( S20, ( { team = Black, role = Soldier }, [] ) )
        , ( S21, ( { team = Black, role = Soldier }, [] ) )
        , ( S22, ( { team = Black, role = Soldier }, [] ) )
        , ( S23, ( { team = Black, role = Soldier }, [] ) )
        , ( S24, ( { team = Black, role = Soldier }, [] ) )
        , ( S25, ( { team = Black, role = Soldier }, [] ) )
        ]


viewCounter : { position : Int } -> Counter -> Html msg
viewCounter { position } counter =
    let
        -- Hex colors based on `Team`/`Role` combo
        { stroke, fill } =
            getCounterHexColors counter

        -- How much px we apply to top CSS property
        marginByPosition : Int
        marginByPosition =
            position * 10
    in
    Svg.svg
        [ SvgAttrs.width "70"
        , SvgAttrs.height "70"
        , SvgAttrs.style <|
            String.join " "
                [ "bottom: " ++ String.fromInt marginByPosition ++ "px;"
                , "z-index: " ++ String.fromInt position ++ ";"
                ]
        , SvgAttrs.class "absolute counter"
        ]
        [ Svg.g []
            [ Svg.rect
                [ SvgAttrs.stroke stroke
                , SvgAttrs.height "9"
                , SvgAttrs.width "60"
                , SvgAttrs.y "40.5"
                , SvgAttrs.x "5"
                , SvgAttrs.fill fill
                ]
                []
            , Svg.ellipse
                [ SvgAttrs.ry "10"
                , SvgAttrs.rx "30"
                , SvgAttrs.cy "50"
                , SvgAttrs.cx "35"
                , SvgAttrs.stroke stroke
                , SvgAttrs.fill fill
                ]
                []
            , Svg.rect
                [ SvgAttrs.height "10"
                , SvgAttrs.width "59"
                , SvgAttrs.y "40"
                , SvgAttrs.x "5.5"
                , SvgAttrs.fill fill
                ]
                []
            , Svg.ellipse
                [ SvgAttrs.ry "10"
                , SvgAttrs.rx "30"
                , SvgAttrs.cy "40"
                , SvgAttrs.cx "35"
                , SvgAttrs.stroke stroke
                , SvgAttrs.fill fill
                ]
                []
            ]
        ]
