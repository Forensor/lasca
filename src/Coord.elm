module Coord exposing
    ( Coord(..)
    , adjacentByDirection
    , allCoords
    , toString
    , topAndLeftValues
    )

import Dict.Any as AnyDict exposing (AnyDict)
import Direction exposing (Direction)
import Set.Any as AnySet exposing (AnySet)


{-| Position code for the `Piece`s over the `Board`.

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


allCoords : AnySet String Coord
allCoords =
    AnySet.fromList toString
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


toString : Coord -> String
toString coord =
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


{-| Get CSS _top_ and _left_ values for `Board` elements' view styles.
-}
topAndLeftValues : Coord -> { top : Int, left : Int }
topAndLeftValues coord =
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


{-| Get a reachable square `Cord` by `Direction`. Note that not all squares reach another
square for every single `Direction`.

Example:

```
adjacentByDirection S1 Direction.UpRight == Just S5 -- ✓ Can reach a `Square` going `↗`
-- But:
adjacentByDirection S1 Direction.UpLeft == Nothing -- ☓ Cannot reach a `Square` there `↖`
```

-}
adjacentByDirection : Coord -> Direction -> Maybe Coord
adjacentByDirection coord direction =
    let
        tupleToComparable : ( Coord, Direction ) -> String
        tupleToComparable ( coord_, direction_ ) =
            toString coord_ ++ "," ++ Direction.toString direction_

        {- With this dictionary we save a lot of space. It works the same way as:

           ```
           case coord of
                S1 ->
                    case direction of
                        Direction.UpLeft ->
                            Nothing
                        Direction.UpRight ->
                            Just S5
                        ...
                ...
           ```

           doing `AnyDict.get ( coord, direction ) directionsDict`.
        -}
        directionsDict : AnyDict String ( Coord, Direction ) Coord
        directionsDict =
            AnyDict.fromList tupleToComparable
                [ -- First row
                  ( ( S1, Direction.UpRight ), S5 )
                , ( ( S2, Direction.UpLeft ), S5 )
                , ( ( S2, Direction.UpRight ), S6 )
                , ( ( S3, Direction.UpLeft ), S6 )
                , ( ( S3, Direction.UpRight ), S7 )
                , ( ( S4, Direction.UpLeft ), S7 )

                -- Second row
                , ( ( S5, Direction.UpLeft ), S8 )
                , ( ( S5, Direction.UpRight ), S9 )
                , ( ( S5, Direction.DownLeft ), S1 )
                , ( ( S5, Direction.DownRight ), S2 )
                , ( ( S6, Direction.UpLeft ), S9 )
                , ( ( S6, Direction.UpRight ), S10 )
                , ( ( S6, Direction.DownLeft ), S2 )
                , ( ( S6, Direction.DownRight ), S3 )
                , ( ( S7, Direction.UpLeft ), S10 )
                , ( ( S7, Direction.UpRight ), S11 )
                , ( ( S7, Direction.DownLeft ), S3 )
                , ( ( S7, Direction.DownRight ), S4 )

                -- Third row
                , ( ( S8, Direction.UpRight ), S12 )
                , ( ( S8, Direction.DownRight ), S5 )
                , ( ( S9, Direction.UpLeft ), S12 )
                , ( ( S9, Direction.UpRight ), S13 )
                , ( ( S9, Direction.DownLeft ), S5 )
                , ( ( S9, Direction.DownRight ), S6 )
                , ( ( S10, Direction.UpLeft ), S13 )
                , ( ( S10, Direction.UpRight ), S14 )
                , ( ( S10, Direction.DownLeft ), S6 )
                , ( ( S10, Direction.DownRight ), S7 )
                , ( ( S11, Direction.UpLeft ), S14 )
                , ( ( S11, Direction.DownLeft ), S7 )

                -- Fourth row
                , ( ( S12, Direction.UpLeft ), S15 )
                , ( ( S12, Direction.UpRight ), S16 )
                , ( ( S12, Direction.DownLeft ), S8 )
                , ( ( S12, Direction.DownRight ), S9 )
                , ( ( S13, Direction.UpLeft ), S16 )
                , ( ( S13, Direction.UpRight ), S17 )
                , ( ( S13, Direction.DownLeft ), S9 )
                , ( ( S13, Direction.DownRight ), S10 )
                , ( ( S14, Direction.UpLeft ), S17 )
                , ( ( S14, Direction.UpRight ), S18 )
                , ( ( S14, Direction.DownLeft ), S10 )
                , ( ( S14, Direction.DownRight ), S11 )

                -- Fifth row
                , ( ( S15, Direction.UpRight ), S19 )
                , ( ( S15, Direction.DownRight ), S12 )
                , ( ( S16, Direction.UpLeft ), S19 )
                , ( ( S16, Direction.UpRight ), S20 )
                , ( ( S16, Direction.DownLeft ), S12 )
                , ( ( S16, Direction.DownRight ), S13 )
                , ( ( S17, Direction.UpLeft ), S20 )
                , ( ( S17, Direction.UpRight ), S21 )
                , ( ( S17, Direction.DownLeft ), S13 )
                , ( ( S17, Direction.DownRight ), S14 )
                , ( ( S18, Direction.UpLeft ), S21 )
                , ( ( S18, Direction.DownLeft ), S14 )

                -- Sixth row
                , ( ( S19, Direction.UpLeft ), S22 )
                , ( ( S19, Direction.UpRight ), S23 )
                , ( ( S19, Direction.DownLeft ), S15 )
                , ( ( S19, Direction.DownRight ), S16 )
                , ( ( S20, Direction.UpLeft ), S23 )
                , ( ( S20, Direction.UpRight ), S24 )
                , ( ( S20, Direction.DownLeft ), S16 )
                , ( ( S20, Direction.DownRight ), S17 )
                , ( ( S21, Direction.UpLeft ), S24 )
                , ( ( S21, Direction.UpRight ), S25 )
                , ( ( S21, Direction.DownLeft ), S17 )
                , ( ( S21, Direction.DownRight ), S18 )

                -- Seventh row
                , ( ( S22, Direction.DownRight ), S19 )
                , ( ( S23, Direction.DownLeft ), S19 )
                , ( ( S23, Direction.DownRight ), S20 )
                , ( ( S24, Direction.DownLeft ), S20 )
                , ( ( S24, Direction.DownRight ), S21 )
                , ( ( S25, Direction.DownLeft ), S21 )
                ]
    in
    AnyDict.get ( coord, direction ) directionsDict
