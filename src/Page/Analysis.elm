module Page.Analysis exposing (..)

import Board exposing (Board)
import Browser exposing (Document)
import Browser.Events as BrEvts
import Capture exposing (Capture)
import CaptureStep exposing (CaptureStep)
import Coord exposing (Coord)
import Fen
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Json.Decode as Decode
import Json.Decode.Extra as Decode
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Move exposing (Move)
import Movement exposing (Movement)
import MovementStep exposing (MovementStep)
import Orientation exposing (Orientation)
import Page
import Pgn
import Piece exposing (Piece)
import PossibleMoves exposing (PossibleMoves)
import Preferences
import Session exposing (Session)
import Set.Any as AnySet exposing (AnySet)
import Sound
import Team exposing (Team)


type alias Model =
    { session : Session
    , game : Game
    , preferencesPanelIsOpen : Bool
    , selectedPiece : Maybe ( Coord, Piece.DraggingState )
    , hoveredCoord : Maybe Coord
    , ongoingCaptureSteps : ( Game, List CaptureStep )
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanelIsOpened Bool
    | EnlargeBoardSize
    | ReduceBoardSize
    | SwapBoardOrientation
    | ReproduceSound String
      -- Mouse position relative to `Board` element
    | DragPiece
        Coord
        { mouseX : Float
        , mouseY : Float
        }
    | DropPiece
        Coord
        { mouseX : Float
        , mouseY : Float
        }
    | GotMouseCoords
        { mouseX : Float
        , mouseY : Float
        }
      ---------------------------------------------
    | SetSelectedPiece (Maybe ( Coord, Piece.DraggingState ))
    | SetHoveredCoord (Maybe Coord)
    | MakeMovementStep MovementStep


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , game = Game.default
      , preferencesPanelIsOpen = False
      , selectedPiece = Nothing
      , hoveredCoord = Nothing
      , ongoingCaptureSteps = ( Game.default, [] )
      }
    , Cmd.none
    )


view : Model -> Document Msg
view model =
    { title = "lasca - Analysis"
    , body =
        body model
    }


body : Model -> List (Html Msg)
body model =
    [ Html.div
        [ Attrs.class "h-screen" ]
        [ Page.viewHeader TogglePreferencesPanel
        , Page.viewIf
            model.preferencesPanelIsOpen
            (Preferences.viewDropdown
                { enlargeBoardSizeButtonMsg = EnlargeBoardSize
                , reduceBoardSizeButtonMsg = ReduceBoardSize
                , swapBoardOrientationMsg = SwapBoardOrientation
                }
            )
        , viewContent model
        ]
    ]


viewContent : Model -> Html Msg
viewContent model =
    Html.div [ Attrs.class "pt-[100px] flex justify-center" ]
        [ viewAnalysisPanel model ]


viewAnalysisPanel : Model -> Html Msg
viewAnalysisPanel model =
    Html.main_ [ Attrs.class "flex flex-col gap-[20px]" ]
        [ Board.view
            { pieceSize = model.session.preferences.pieceSize
            , orientation = model.session.preferences.orientation
            , selectedPiece = model.selectedPiece
            , possibleMoves = model.game.possibleMoves
            , onDragPieceEventToMsg = DragPiece
            , hoveredCoord = model.hoveredCoord
            , hoveredCoordToMsg = SetHoveredCoord
            , onClickMoveDestinationToMsg = MakeMovementStep
            , playingTurn = model.game.turn
            }
            model.game.board
        , Html.text <| Fen.toString <| Fen.fromGame model.game
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "msg" msg of
        NoOp _ ->
            ( model, Cmd.none )

        TogglePreferencesPanel ->
            let
                newPreferencesPanelIsOpen : Bool
                newPreferencesPanelIsOpen =
                    not model.preferencesPanelIsOpen
            in
            ( { model
                | preferencesPanelIsOpen = newPreferencesPanelIsOpen
              }
            , Cmd.none
            )

        SetPreferencesPanelIsOpened preferencesPanelIsOpen ->
            ( { model
                | preferencesPanelIsOpen = preferencesPanelIsOpen
              }
            , Cmd.none
            )

        EnlargeBoardSize ->
            let
                { session } =
                    model

                { preferences } =
                    session

                newPieceSize : Float
                newPieceSize =
                    if preferences.pieceSize + 17.5 > 140 then
                        preferences.pieceSize

                    else
                        preferences.pieceSize + 17.5
            in
            ( { model
                | session =
                    { session
                        | preferences =
                            { preferences
                                | pieceSize = newPieceSize
                            }
                    }
              }
            , Cmd.none
            )

        ReduceBoardSize ->
            let
                { session } =
                    model

                { preferences } =
                    session

                newPieceSize : Float
                newPieceSize =
                    if preferences.pieceSize - 17.5 < 35 then
                        preferences.pieceSize

                    else
                        preferences.pieceSize - 17.5
            in
            ( { model
                | session =
                    { session
                        | preferences =
                            { preferences
                                | pieceSize = newPieceSize
                            }
                    }
              }
            , Cmd.none
            )

        SwapBoardOrientation ->
            let
                { session } =
                    model

                { preferences } =
                    session

                newBoardOrientation : Orientation
                newBoardOrientation =
                    case preferences.orientation of
                        Orientation.Whiteside ->
                            Orientation.Blackside

                        Orientation.Blackside ->
                            Orientation.Whiteside
            in
            ( { model
                | session =
                    { session
                        | preferences =
                            { preferences
                                | orientation = newBoardOrientation
                            }
                    }
              }
            , Cmd.none
            )

        ReproduceSound soundFilename ->
            ( model, Sound.play soundFilename )

        DragPiece coord mouseCoords ->
            ( { model
                | selectedPiece =
                    Just
                        ( coord
                        , Piece.Dragged mouseCoords
                        )
              }
            , Cmd.none
            )

        DropPiece coord mouseCoords ->
            let
                newSelectedPiece : Maybe ( Coord, Piece.DraggingState )
                newSelectedPiece =
                    if model.hoveredCoord == Just coord then
                        Just ( coord, Piece.Static )

                    else
                        Nothing

                maybePossibleMoveSingleton : Maybe PossibleMoves
                maybePossibleMoveSingleton =
                    Maybe.map2
                        (\( originCoord, _ ) destinationCoord ->
                            PossibleMoves.filterByOriginAndDestinationCoords
                                originCoord
                                destinationCoord
                                model.game.possibleMoves
                        )
                        model.selectedPiece
                        model.hoveredCoord

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
            in
            case maybeMovementStep of
                Just movementStep ->
                    update (MakeMovementStep movementStep) model

                Nothing ->
                    ( { model
                        | selectedPiece = newSelectedPiece
                      }
                    , Cmd.none
                    )

        GotMouseCoords mouseCoords ->
            ( { model
                | selectedPiece =
                    model.selectedPiece
                        |> Maybe.map
                            (\( coord, draggingState ) ->
                                case draggingState of
                                    Piece.Static ->
                                        ( coord
                                        , Piece.Static
                                        )

                                    Piece.Dragged _ ->
                                        ( coord
                                        , Piece.Dragged mouseCoords
                                        )
                            )
              }
            , Cmd.none
            )

        SetSelectedPiece selectedPiece ->
            ( { model
                | selectedPiece = selectedPiece
              }
            , Cmd.none
            )

        SetHoveredCoord maybeCoord ->
            ( { model | hoveredCoord = maybeCoord }, Cmd.none )

        MakeMovementStep movementStep ->
            let
                newGame : Game
                newGame =
                    case movementStep of
                        MovementStep.Move move ->
                            Game.makeMovement model.game (Movement.Move move)

                        MovementStep.CaptureStep captureStep ->
                            let
                                gameWithCaptureStepDone : Game
                                gameWithCaptureStepDone =
                                    Game.makeCaptureStep model.game captureStep
                            in
                            if gameWithCaptureStepDone.turn == model.game.turn then
                                gameWithCaptureStepDone

                            else
                                model.ongoingCaptureSteps
                                    |> (\( gameBeforeFirstCaptureStep, captureSteps ) ->
                                            NonEmpty.fromList
                                                (captureSteps
                                                    ++ [ captureStep ]
                                                )
                                                |> Maybe.map
                                                    (\nonEmptyCaptureSteps ->
                                                        Game.makeMovement
                                                            gameBeforeFirstCaptureStep
                                                            (Movement.Capture
                                                                nonEmptyCaptureSteps
                                                            )
                                                    )
                                                |> Maybe.withDefault
                                                    gameBeforeFirstCaptureStep
                                       )

                newSelectedPiece : Maybe ( Coord, Piece.DraggingState )
                newSelectedPiece =
                    case movementStep of
                        MovementStep.Move _ ->
                            Nothing

                        MovementStep.CaptureStep captureStep ->
                            if newGame.turn == model.game.turn then
                                Just ( captureStep.destination, Piece.Static )

                            else
                                Nothing

                newOngoingCaptureSteps : ( Game, List CaptureStep )
                newOngoingCaptureSteps =
                    case movementStep of
                        MovementStep.Move _ ->
                            ( newGame, [] )

                        MovementStep.CaptureStep captureStep ->
                            if newGame.turn == model.game.turn then
                                ( Tuple.first model.ongoingCaptureSteps
                                , Tuple.second model.ongoingCaptureSteps
                                    ++ [ captureStep ]
                                )

                            else
                                ( newGame, [] )

                playSoundCmd : Cmd msg
                playSoundCmd =
                    case movementStep of
                        MovementStep.Move _ ->
                            Sound.play Move.soundFilename

                        MovementStep.CaptureStep captureStep ->
                            Sound.play CaptureStep.soundFilename
            in
            ( { model
                | game = newGame
                , selectedPiece = newSelectedPiece
                , ongoingCaptureSteps = newOngoingCaptureSteps
              }
            , playSoundCmd
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        ((-- Get mouse coords when dragging a `Piece` and drop it when you mouseup
          case model.selectedPiece of
            Just ( coord, Piece.Dragged { mouseX, mouseY } ) ->
                [ BrEvts.onMouseMove
                    (Decode.succeed
                        (\mouseX_ mouseY_ ->
                            GotMouseCoords
                                { mouseX = mouseX_
                                , mouseY = mouseY_
                                }
                        )
                        |> Decode.andMap (Decode.field "clientX" Decode.float)
                        |> Decode.andMap (Decode.field "clientY" Decode.float)
                    )
                , BrEvts.onMouseUp
                    (Decode.succeed
                        (DropPiece coord
                            { mouseX = mouseX
                            , mouseY = mouseY
                            }
                        )
                    )
                ]

            _ ->
                [ Sub.none ]
         )
            ++ (-- Unselect piece when clicking outside
                case model.selectedPiece of
                    Just _ ->
                        [ Page.mouseDownOutsideElementClassesEvent
                            (SetSelectedPiece Nothing)
                            [ Piece.className, Board.moveDestinationClassName ]
                        ]

                    _ ->
                        [ Sub.none ]
               )
            ++ [ -- Close preferences panel when clicking outside
                 if model.preferencesPanelIsOpen then
                    Page.mouseDownOutsideElementIdsEvent
                        (SetPreferencesPanelIsOpened False)
                        [ Preferences.dropdownId, Preferences.gearButtonId ]

                 else
                    Sub.none
               ]
        )
