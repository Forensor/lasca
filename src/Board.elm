module Board exposing
    ( Board
    , className
    , default
    , moveDestinationClassName
    , selectedSquareClassName
    , view
    )

{-| A `Board` is a representation of the placement of the `Piece`s on a "physical board".
-}

import Coord exposing (Coord)
import Dict.Any as AnyDict exposing (AnyDict)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode
import Json.Decode.Extra as Decode
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Movement exposing (Movement)
import MovementStep exposing (MovementStep)
import Orientation exposing (Orientation)
import Piece exposing (Piece)
import PossibleMoves exposing (PossibleMoves)
import Role
import Set.Any as AnySet exposing (AnySet)
import Svg.Attributes as SvgAttrs
import Team exposing (Team)


{-| Game position represented by an `AnyDict`.

Any `Coord` not present in the dictionary means that the square is empty.

-}
type alias Board =
    AnyDict Int Coord Piece


{-| Default starting position `Board`.
-}
default : Board
default =
    AnyDict.fromList Coord.toInt
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
type alias Config msg =
    { pieceSize : Float
    , orientation : Orientation
    , selectedPiece : Maybe ( Coord, Piece.DraggingState )
    , possibleMoves : PossibleMoves
    , onDragPieceEventToMsg : Coord -> { mouseX : Float, mouseY : Float } -> msg
    , hoveredCoord : Maybe Coord
    , hoveredCoordToMsg : Maybe Coord -> msg
    , onClickMoveDestinationToMsg : MovementStep -> msg
    , playingTurn : Team
    }


view : Config msg -> Board -> Html msg
view config board =
    let
        sizeByPieceSize : Float
        sizeByPieceSize =
            config.pieceSize * 7

        selectedSquareView : List (Html msg)
        selectedSquareView =
            case config.selectedPiece of
                Just ( coord, _ ) ->
                    [ viewSelectedSquare config coord ]

                Nothing ->
                    []

        moveDestinationsView : List (Html msg)
        moveDestinationsView =
            case ( config.possibleMoves, config.selectedPiece ) of
                ( PossibleMoves.Captures captures, Just ( coord, _ ) ) ->
                    captures
                        |> AnySet.toList
                        |> List.filter (.origin >> (==) coord)
                        |> List.map (.destination >> viewMoveDestination config)

                ( PossibleMoves.Moves moves, Just ( coord, _ ) ) ->
                    moves
                        |> AnySet.toList
                        |> List.filter (.origin >> (==) coord)
                        |> List.map (.destination >> viewMoveDestination config)

                _ ->
                    []
    in
    Html.node "board"
        [ Attrs.class className
        , Attrs.class "block relative cursor-pointer"
        , SvgAttrs.style <|
            String.join " "
                [ "height: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                , "width: " ++ String.fromFloat sizeByPieceSize ++ "px;"
                ]
        , Attrs.class "bg-board bg-no-repeat bg-cover rounded-[4px] shadow-lg"
        , Attrs.id playingBoardId
        ]
        (selectedSquareView
            ++ moveDestinationsView
            ++ (board
                    |> AnyDict.toList
                    |> List.map
                        (\( coord, piece ) ->
                            Piece.view
                                { pieceSize = config.pieceSize
                                , orientation = config.orientation
                                , selectedPiece = config.selectedPiece
                                , onDragPieceEventToMsg =
                                    config.onDragPieceEventToMsg
                                , hoveredCoordToMsg = config.hoveredCoordToMsg
                                , shouldHaveEvents =
                                    config.playingTurn
                                        == Piece.team piece
                                }
                                coord
                                piece
                        )
               )
        )


className : String
className =
    "board"


playingBoardId : String
playingBoardId =
    "playing-board"


moveDestinationClassName : String
moveDestinationClassName =
    "move-dest"


capturedSquareClassName : String
capturedSquareClassName =
    "capt-square"


selectedSquareClassName : String
selectedSquareClassName =
    "slc-square"


lastMoveClassName : String
lastMoveClassName =
    "last-move"


ghostPieceClassName : String
ghostPieceClassName =
    "ghost"


viewMoveDestination : Config msg -> Coord -> Html msg
viewMoveDestination config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord

        backgroundBasedOnHovering : String
        backgroundBasedOnHovering =
            if config.hoveredCoord == Just coord then
                "bg-[rgba(20,_85,_30,_.3)]"

            else
                "bg-[radial-gradient(rgba(20,_85,_30,_0.5)_19%,_rgba(0,_0,_0,_0)_20%)]"

        maybePossibleMoveSingleton : Maybe PossibleMoves
        maybePossibleMoveSingleton =
            config.selectedPiece
                |> Maybe.map
                    (Tuple.first
                        >> (\originCoord ->
                                PossibleMoves.filterByOriginAndDestinationCoords
                                    originCoord
                                    coord
                                    config.possibleMoves
                           )
                    )

        maybeMovementStep : Maybe MovementStep
        maybeMovementStep =
            case maybePossibleMoveSingleton of
                Just (PossibleMoves.Captures captures) ->
                    case AnySet.toList captures of
                        [ capture ] ->
                            Just <| MovementStep.CaptureStep capture

                        _ ->
                            Nothing

                Just (PossibleMoves.Moves moves) ->
                    case AnySet.toList moves of
                        [ move ] ->
                            Just <| MovementStep.Move move

                        _ ->
                            Nothing

                _ ->
                    Nothing

        onClickMoveDestinationEvent : List (Attribute msg)
        onClickMoveDestinationEvent =
            case maybeMovementStep of
                Just (MovementStep.CaptureStep capture) ->
                    [ Events.onClick <|
                        config.onClickMoveDestinationToMsg <|
                            MovementStep.CaptureStep capture
                    ]

                Just (MovementStep.Move move) ->
                    [ Events.onClick <|
                        config.onClickMoveDestinationToMsg <|
                            MovementStep.Move move
                    ]

                Nothing ->
                    []
    in
    Html.node "move-dest"
        ([ Attrs.class moveDestinationClassName
         , Attrs.class "block absolute"
         , Events.onMouseOver <| config.hoveredCoordToMsg (Just coord)
         , Events.onMouseLeave <| config.hoveredCoordToMsg Nothing
         , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
         , Attrs.class backgroundBasedOnHovering
         ]
            ++ onClickMoveDestinationEvent
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


viewSelectedSquare : Config msg -> Coord -> Html msg
viewSelectedSquare config coord =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "slc-square"
        [ Attrs.class selectedSquareClassName
        , Attrs.class "block absolute"
        , Events.onMouseOver <| config.hoveredCoordToMsg (Just coord)
        , Events.onMouseLeave <| config.hoveredCoordToMsg Nothing
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


viewLastMoveSquare : Config msg -> Coord -> Html msg
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


viewGhostPiece : Config msg -> Coord -> Piece -> Html msg
viewGhostPiece config coord piece =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "ghost"
        [ Attrs.class ghostPieceClassName
        , Attrs.class "block absolute"
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromFloat top ++ "px;"
                , "left: " ++ String.fromFloat left ++ "px;"
                , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                ]
        ]
        [ Piece.view
            { pieceSize = config.pieceSize
            , orientation = config.orientation
            , selectedPiece = config.selectedPiece
            , onDragPieceEventToMsg = config.onDragPieceEventToMsg
            , hoveredCoordToMsg = config.hoveredCoordToMsg
            , shouldHaveEvents = False
            }
            coord
            piece
        ]
