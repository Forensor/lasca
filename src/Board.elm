module Board exposing (..)

import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Html)
import Html.Attributes as Attrs
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Svg
import Svg.Attributes as SvgAttrs


{-| Position code for the pieces on the `Board`.

This follows the usual
[draughts board's coordinates distribution](https://pjb.com.au/laska/laskers_rules.html).

-}
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


{-| `Piece`s are stacks of `Counter`s. The head of the `NonEmpty` represents the topmost
`Counter` of the stack, which designs the `Team` and the `Role` of it.
-}
type alias Piece =
    NonEmpty Counter


type alias Board =
    AnyDict String Coord Piece


{-| `Direction`s where `Piece`s can go.

`UpLeft` means `↖`, `UpRight` means `↗`, and so on...

-}
type Direction
    = UpLeft
    | UpRight
    | DownLeft
    | DownRight


allCoords : List Coord
allCoords =
    [ S1
    , S2
    , S3
    , S4
    , S5
    , S6
    , S7
    , S8
    , S9
    , S10
    , S11
    , S12
    , S13
    , S14
    , S15
    , S16
    , S17
    , S18
    , S19
    , S20
    , S21
    , S22
    , S23
    , S24
    , S25
    ]


{-| Default starting position `Board`.
-}
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


{-| Get a reachable square `Cord` by `Direction`. Note that not all squares reach another
square for every single `Direction`.

Example:

```
getAdjacentCoordByDirection S1 UpRight == Just S5 -- ✓ Can reach a `Square` going `↗`
-- But:
getAdjacentCoordByDirection S1 UpLeft == Nothing -- ☓ Cannot reach a `Square` there `↖`
```

-}
getAdjacentCoordByDirection : Coord -> Direction -> Maybe Coord
getAdjacentCoordByDirection coord direction =
    let
        tupleToComparable : ( Coord, Direction ) -> String
        tupleToComparable ( coord_, direction_ ) =
            coordToString coord_ ++ "," ++ directionToString direction_

        {- With this dictionary we save a lot of space. It works the same way as:
           ```
           case coord of
                S1 ->
                    case direction of
                        UpLeft ->
                            Nothing
                        UpRight ->
                            Just S5
                        ...
                ...
           ```
        -}
        directionsDict : AnyDict String ( Coord, Direction ) Coord
        directionsDict =
            AnyDict.fromList tupleToComparable
                [ -- First row
                  ( ( S1, UpRight ), S5 )
                , ( ( S2, UpLeft ), S5 )
                , ( ( S2, UpRight ), S6 )
                , ( ( S3, UpLeft ), S6 )
                , ( ( S3, UpRight ), S7 )
                , ( ( S4, UpLeft ), S7 )

                -- Second row
                , ( ( S5, UpLeft ), S8 )
                , ( ( S5, UpRight ), S9 )
                , ( ( S5, DownLeft ), S1 )
                , ( ( S5, DownRight ), S2 )
                , ( ( S6, UpLeft ), S9 )
                , ( ( S6, UpRight ), S10 )
                , ( ( S6, DownLeft ), S2 )
                , ( ( S6, DownRight ), S3 )
                , ( ( S7, UpLeft ), S10 )
                , ( ( S7, UpRight ), S11 )
                , ( ( S7, DownLeft ), S3 )
                , ( ( S7, DownRight ), S4 )

                -- Third row
                , ( ( S8, UpRight ), S12 )
                , ( ( S8, DownRight ), S5 )
                , ( ( S9, UpLeft ), S12 )
                , ( ( S9, UpRight ), S13 )
                , ( ( S9, DownLeft ), S5 )
                , ( ( S9, DownRight ), S6 )
                , ( ( S10, UpLeft ), S13 )
                , ( ( S10, UpRight ), S14 )
                , ( ( S10, DownLeft ), S6 )
                , ( ( S10, DownRight ), S7 )
                , ( ( S11, UpLeft ), S14 )
                , ( ( S11, DownLeft ), S7 )

                -- Fourth row
                , ( ( S12, UpLeft ), S15 )
                , ( ( S12, UpRight ), S16 )
                , ( ( S12, DownLeft ), S8 )
                , ( ( S12, DownRight ), S9 )
                , ( ( S13, UpLeft ), S16 )
                , ( ( S13, UpRight ), S17 )
                , ( ( S13, DownLeft ), S9 )
                , ( ( S13, DownRight ), S10 )
                , ( ( S14, UpLeft ), S17 )
                , ( ( S14, UpRight ), S18 )
                , ( ( S14, DownLeft ), S10 )
                , ( ( S14, DownRight ), S11 )

                -- Fifth row
                , ( ( S15, UpRight ), S19 )
                , ( ( S15, DownRight ), S12 )
                , ( ( S16, UpLeft ), S19 )
                , ( ( S16, UpRight ), S20 )
                , ( ( S16, DownLeft ), S12 )
                , ( ( S16, DownRight ), S13 )
                , ( ( S17, UpLeft ), S20 )
                , ( ( S17, UpRight ), S21 )
                , ( ( S17, DownLeft ), S13 )
                , ( ( S17, DownRight ), S14 )
                , ( ( S18, UpLeft ), S21 )
                , ( ( S18, DownLeft ), S14 )

                -- Sixth row
                , ( ( S19, UpLeft ), S22 )
                , ( ( S19, UpRight ), S23 )
                , ( ( S19, DownLeft ), S15 )
                , ( ( S19, DownRight ), S16 )
                , ( ( S20, UpLeft ), S23 )
                , ( ( S20, UpRight ), S24 )
                , ( ( S20, DownLeft ), S16 )
                , ( ( S20, DownRight ), S17 )
                , ( ( S21, UpLeft ), S24 )
                , ( ( S21, UpRight ), S25 )
                , ( ( S21, DownLeft ), S17 )
                , ( ( S21, DownRight ), S18 )

                -- Seventh row
                , ( ( S22, DownRight ), S19 )
                , ( ( S23, DownLeft ), S19 )
                , ( ( S23, DownRight ), S20 )
                , ( ( S24, DownLeft ), S20 )
                , ( ( S24, DownRight ), S21 )
                , ( ( S25, DownLeft ), S21 )
                ]
    in
    directionsDict
        |> AnyDict.get ( coord, direction )


{-| Get _svg_'s _stroke_ and _fill_ values for `Piece` view styles.
-}
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


directionToString : Direction -> String
directionToString direction =
    case direction of
        UpLeft ->
            "UpLeft"

        UpRight ->
            "UpRight"

        DownLeft ->
            "DownLeft"

        DownRight ->
            "DownRight"


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


{-| Get CSS _top_ and _left_ values for `Piece` view styles.
-}
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


{-| Render a `Piece` on a specific `Coord`.
-}
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
                        positionOnStack : Int
                        positionOnStack =
                            (NonEmpty.length piece - 1) - index
                    in
                    viewCounter { positionOnStack = positionOnStack } counter
                )
            |> NonEmpty.toList
        )


{-| Render a single `Counter`. _stroke_ and _fill_ colors for the _svg_ are based on the
`Team`/`Role` combo. _bottom_ CSS property is based on `positionOnStack`, the higher the
value, the higher the `Counter` will be.
-}
viewCounter : { positionOnStack : Int } -> Counter -> Html msg
viewCounter { positionOnStack } counter =
    let
        -- Hex colors based on Team/Role combo
        { stroke, fill } =
            getCounterHexColors counter

        -- How much px we apply to bottom CSS property
        marginByPosition : Int
        marginByPosition =
            positionOnStack * 10
    in
    Svg.svg
        [ SvgAttrs.width "70"
        , SvgAttrs.height "70"
        , SvgAttrs.style <|
            String.join " "
                [ "bottom: " ++ String.fromInt marginByPosition ++ "px;"
                , "z-index: " ++ String.fromInt positionOnStack ++ ";"
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
