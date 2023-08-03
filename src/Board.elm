module Board exposing (Board, Msg, defaultBoard, view)

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


type Msg
    = PieceMsg Piece.Msg


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


view : { pieceSize : Int } -> Board -> Html Msg
view { pieceSize } board =
    let
        sizeByPieceSize : Int
        sizeByPieceSize =
            pieceSize * 7
    in
    Html.node "board"
        [ Attrs.class "board block relative"
        , SvgAttrs.style <|
            String.join " "
                [ "height: " ++ String.fromInt sizeByPieceSize ++ "px;"
                , "width: " ++ String.fromInt sizeByPieceSize ++ "px;"
                ]
        , Attrs.class "bg-board bg-no-repeat bg-cover rounded-[4px] shadow-lg"
        ]
        (board
            |> AnyDict.toList
            |> List.map
                (\( coord, piece ) ->
                    Piece.view { pieceSize = pieceSize } coord piece
                        |> Html.map PieceMsg
                )
        )


viewMoveDestination : { pieceSize : Int } -> Coord -> Html msg
viewMoveDestination { pieceSize } coord =
    let
        { top, left } =
            Coord.topAndLeftValues { pieceSize = pieceSize } coord
    in
    Html.div
        [ Attrs.class "move-destination"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromInt top ++ "px;"
                , "left: " ++ String.fromInt left ++ "px;"
                , "height: " ++ String.fromInt pieceSize ++ "px;"
                , "width: " ++ String.fromInt pieceSize ++ "px;"
                ]
        ]
        []
