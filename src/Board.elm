module Board exposing (Board, defaultBoard, view)

import Coord exposing (Coord)
import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Html)
import Html.Attributes as Attrs
import Piece exposing (Piece)
import Role
import Svg.Attributes as SvgAttrs
import Team


{-| Game position represented by an `AnyDict`.

Any `Coord` not present in the dictionary means that the square is empty.

-}
type alias Board =
    AnyDict String Coord Piece


{-| Default starting position `Board`.
-}
defaultBoard : Board
defaultBoard =
    AnyDict.fromList Coord.toString
        [ ( Coord.S1, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S2, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S3, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S4, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S5, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S6, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S7, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S8, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S9, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S10, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S11, ( { team = Team.White, role = Role.Soldier }, [] ) )
        , ( Coord.S15, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S16, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S17, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S18, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S19, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S20, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S21, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S22, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S23, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S24, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        , ( Coord.S25, ( { team = Team.Black, role = Role.Soldier }, [] ) )
        ]


view : Board -> Html msg
view board =
    Html.node "board"
        [ Attrs.class
            "board block w-[490px] h-[490px] bg-board bg-no-repeat bg-cover relative"
        ]
        (board
            |> AnyDict.toList
            |> List.map
                (\( coord, piece ) ->
                    Piece.view coord piece
                )
        )


viewMoveDestination : Coord -> Html msg
viewMoveDestination coord =
    let
        { top, left } =
            Coord.topAndLeftValues coord
    in
    Html.div
        [ Attrs.class "move-destination w-[70px] h-[70px]"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromInt top ++ "px;"
                , "left: " ++ String.fromInt left ++ "px;"
                ]
        ]
        []
