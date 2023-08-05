module Board exposing (Board, defaultBoard, view)

import Coord exposing (Coord)
import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import MovementType exposing (MovementType)
import Orientation exposing (Orientation)
import Page
import Piece exposing (Piece)
import PossibleMoves exposing (PossibleMoves)
import Role
import Set.Any as AnySet exposing (AnySet)
import Svg.Attributes as SvgAttrs
import Team


{-| Game position represented by an `AnyDict`.

Any `Coord` not present in the dictionary means that the square is empty.

-}
type alias Board =
    AnyDict String Coord Piece


type alias Config msg =
    { onClickPieceToMsg : Coord -> msg
    , pieceSize : Float
    , orientation : Orientation
    , moveDestinations : AnySet String Coord
    , pieceSelected : Maybe Coord
    , onClickOutsidePieceSelectedMsg : msg
    , highlightedSquares : AnySet String Coord
    , onClickMoveDestinationToMsg : MovementType -> msg
    , possibleMoves : PossibleMoves
    }


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


view : Config msg -> Board -> Html msg
view config board =
    let
        sizeByPieceSize : Float
        sizeByPieceSize =
            config.pieceSize * 7

        clickOutsidePieceSelectedEvent : List (Attribute msg)
        clickOutsidePieceSelectedEvent =
            case config.pieceSelected of
                Just _ ->
                    [ Page.clickOutsideElementClassesEvent
                        config.onClickOutsidePieceSelectedMsg
                        [ Piece.className, moveDestClassName, Piece.selectedClassName ]
                    ]

                Nothing ->
                    []
    in
    Html.node "board"
        (clickOutsidePieceSelectedEvent
            ++ [ Attrs.class "board block relative cursor-pointer"
               , SvgAttrs.style <|
                    String.join " "
                        [ "height: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                        , "width: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                        ]
               , Attrs.class "bg-board bg-no-repeat bg-cover rounded-[4px] shadow-lg"
               ]
        )
        ((config.highlightedSquares
            |> AnySet.toList
            |> List.map
                (\coord ->
                    viewHighlightedSquare config coord
                )
         )
            ++ (board
                    |> AnyDict.toList
                    |> List.map
                        (\( coord, piece ) ->
                            Piece.view
                                { clickPieceToMsg = config.onClickPieceToMsg
                                , pieceSize = config.pieceSize
                                , orientation = config.orientation
                                , selected = Just coord == config.pieceSelected
                                }
                                coord
                                piece
                        )
               )
            ++ (config.moveDestinations
                    |> AnySet.toList
                    |> List.map
                        (\coord ->
                            viewMoveDestination config coord
                        )
               )
        )


moveDestClassName : String
moveDestClassName =
    "move-dest"


viewMoveDestination : Config msg -> Coord -> Html msg
viewMoveDestination config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord

        maybeFilteredMoveToMake : Maybe PossibleMoves
        maybeFilteredMoveToMake =
            config.pieceSelected
                |> Maybe.map
                    (\originCoord ->
                        PossibleMoves.filterByOriginAndDestinationCoords
                            originCoord
                            coord
                            config.possibleMoves
                    )

        maybeMovementTypeToMake : Maybe MovementType
        maybeMovementTypeToMake =
            case maybeFilteredMoveToMake of
                Just (PossibleMoves.Captures captures) ->
                    case AnySet.toList captures of
                        [ capture ] ->
                            Just <| MovementType.Capture capture

                        _ ->
                            Nothing

                Just (PossibleMoves.Moves moves) ->
                    case AnySet.toList moves of
                        [ move ] ->
                            Just <| MovementType.Move move

                        _ ->
                            Nothing

                _ ->
                    Nothing

        onClickMoveDestinationEvent : List (Attribute msg)
        onClickMoveDestinationEvent =
            case maybeMovementTypeToMake of
                Just (MovementType.Capture capture) ->
                    [ Events.onClick <|
                        config.onClickMoveDestinationToMsg <|
                            MovementType.Capture capture
                    ]

                Just (MovementType.Move move) ->
                    [ Events.onClick <|
                        config.onClickMoveDestinationToMsg <|
                            MovementType.Move move
                    ]

                Nothing ->
                    []
    in
    Html.node "move-dest"
        (onClickMoveDestinationEvent
            ++ [ Attrs.class moveDestClassName
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
        )
        []


viewCapturedSquare : Config msg -> Coord -> Html msg
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
        [ Attrs.class moveDestClassName
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


viewHighlightedSquare : Config msg -> Coord -> Html msg
viewHighlightedSquare { pieceSize, orientation } coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = pieceSize
                , orientation = orientation
                }
                coord
    in
    Html.node "move-dest"
        [ Attrs.class moveDestClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat pieceSize ++ "px;"
                , "width: " ++ String.fromFloat pieceSize ++ "px;"
                ]
        , Attrs.class
            "bg-[rgba(20,_85,_30,_.5)]"
        ]
        []
