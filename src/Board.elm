module Board exposing (Board, default, view)

{-| A `Board` is a representation of the placement of the `Piece`s on a "physical board".
-}

import Coord exposing (Coord)
import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Orientation exposing (Orientation)
import Piece exposing (Piece)
import Role
import Set.Any as AnySet exposing (AnySet)
import Svg.Attributes as SvgAttrs
import Team


{-| Game position represented by an `AnyDict`.

Any `Coord` not present in the dictionary means that the square is empty.

-}
type alias Board =
    AnyDict String Coord Piece


{-| Default starting position `Board`.
-}
default : Board
default =
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



-- All view related stuff is beyond here


{-| Configuration for `Board` related views.
-}
type alias Config =
    { pieceSize : Float
    , orientation : Orientation
    }


view : Config -> Board -> Html msg
view config board =
    let
        sizeByPieceSize : Float
        sizeByPieceSize =
            config.pieceSize * 7
    in
    Html.node "board"
        [ Attrs.class "board block relative cursor-pointer"
        , SvgAttrs.style <|
            String.join " "
                [ "height: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                , "width: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                ]
        , Attrs.class "bg-board bg-no-repeat bg-cover rounded-[4px] shadow-lg"
        ]
        (board
            |> AnyDict.toList
            |> List.map
                (\( coord, piece ) ->
                    Piece.view
                        { pieceSize = config.pieceSize
                        , orientation = config.orientation
                        }
                        coord
                        piece
                )
        )


moveDestinationClassName : String
moveDestinationClassName =
    "move-dest"


capturedSquareClassName : String
capturedSquareClassName =
    "capt-square"


highlightedSquareClassName : String
highlightedSquareClassName =
    "hlg-square"


lastMoveClassName : String
lastMoveClassName =
    "last-move"


viewMoveDestination : Config -> Coord -> Html msg
viewMoveDestination config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "move-dest"
        [ Attrs.class moveDestinationClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
        , Attrs.class
            "bg-[radial-gradient(rgba(20,_85,_30,_0.5)_19%,_rgba(0,_0,_0,_0)_20%)]"
        , Attrs.class "hover:bg-[rgba(20,_85,_30,_.3)]"
        ]
        []


viewCapturedSquare : Config -> Coord -> Html msg
viewCapturedSquare config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "capt-square"
        [ Attrs.class capturedSquareClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
        , Attrs.class
            "radial-gradient(transparent_0%,_transparent_79%,_rgba(20,_85,_0,_0.3)_80%)"
        , Attrs.class "hover:bg-[rgba(20,_85,_30,_.3)]"
        ]
        []


viewHighlightedSquare : Config -> Coord -> Html msg
viewHighlightedSquare config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "hlg-square"
        [ Attrs.class highlightedSquareClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
        , Attrs.class
            "bg-[rgba(20,_85,_30,_.5)]"
        ]
        []


viewLastMoveSquare : Config -> Coord -> Html msg
viewLastMoveSquare config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "last-move"
        [ Attrs.class lastMoveClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
        , Attrs.class
            "bg-[rgba(20,_85,_30,_.5)]"
        ]
        []
