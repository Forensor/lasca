module Page.Analysis exposing (..)

import Board exposing (Board)
import Browser exposing (Document)
import Capture exposing (Capture)
import Coord exposing (Coord)
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Move exposing (Move)
import MovementType exposing (MovementType)
import Orientation exposing (Orientation)
import Page
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
    , preferencesPanelState : Preferences.PanelState
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanel Preferences.PanelState
    | EnlargeBoardSize
    | ReduceBoardSize
    | SwapBoardOrientation
    | ClickPiece Coord
    | SetPieceSelected (Maybe Coord)
    | MakeMove MovementType
    | ReproduceSound String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , game = Game.defaultGame
      , preferencesPanelState = Preferences.Closed
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
    let
        {- Event to handle the close of the `Preferences` dropdown if the user clicks
           anywhere outside of it.

           We do not trigger the event if the `Preferences` dropdown is invisible
        -}
        clickOutsidePreferencesPanelEvent : List (Attribute Msg)
        clickOutsidePreferencesPanelEvent =
            if model.preferencesPanelState == Preferences.Opened then
                [ Page.clickOutsideElementIdsEvent
                    (SetPreferencesPanel Preferences.Closed)
                    [ Preferences.dropdownId, Preferences.gearButtonId ]
                ]

            else
                []
    in
    [ Html.div
        (clickOutsidePreferencesPanelEvent
            ++ [ Attrs.class "h-screen" ]
        )
        [ Page.viewHeader TogglePreferencesPanel
        , Page.viewIf
            (model.preferencesPanelState == Preferences.Opened)
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
    let
        backgroundAndColorClassesBasedOnTurn : Attribute Msg
        backgroundAndColorClassesBasedOnTurn =
            case model.game.turn of
                Team.White ->
                    Attrs.class "bg-white"

                Team.Black ->
                    Attrs.class "bg-[#0A0A0A] text-white"

        moveDestinations : AnySet String Coord
        moveDestinations =
            case model.game.pieceSelected of
                Just coord ->
                    Game.getMoveDestinationCoordsByCoord model.game coord

                Nothing ->
                    AnySet.empty Coord.toString

        highlightedSquares : AnySet String Coord
        highlightedSquares =
            case model.game.pieceSelected of
                Just coord ->
                    AnySet.fromList Coord.toString [ coord ]

                Nothing ->
                    AnySet.empty Coord.toString
    in
    Html.main_ [ Attrs.class "flex flex-col gap-[20px]" ]
        [ Board.view
            { pieceSize = model.session.preferences.pieceSize
            , orientation = model.session.preferences.orientation
            , onClickPieceToMsg = ClickPiece
            , moveDestinations =
                moveDestinations
            , pieceSelected = model.game.pieceSelected
            , onClickOutsidePieceSelectedMsg = SetPieceSelected Nothing
            , highlightedSquares = highlightedSquares
            , onClickMoveDestinationToMsg = MakeMove
            , possibleMoves = model.game.possibleMoves
            }
            model.game.board
        , Html.div
            [ Attrs.class "rounded-[4px] shadow-lg text-[20px] p-[10px] select-none"
            , Attrs.class "w-[150px] text-center"
            , backgroundAndColorClassesBasedOnTurn
            ]
            [ Html.b []
                [ Html.text <| Team.toString model.game.turn ]
            , Html.text "'s turn"
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )

        TogglePreferencesPanel ->
            let
                newPanelState : Preferences.PanelState
                newPanelState =
                    case model.preferencesPanelState of
                        Preferences.Closed ->
                            Preferences.Opened

                        Preferences.Opened ->
                            Preferences.Closed
            in
            ( { model | preferencesPanelState = newPanelState }, Cmd.none )

        SetPreferencesPanel preferencesPanelState ->
            ( { model | preferencesPanelState = preferencesPanelState }, Cmd.none )

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

        ClickPiece coord ->
            let
                { game } =
                    model

                newPieceSelected : Maybe Coord
                newPieceSelected =
                    if Just coord == game.pieceSelected then
                        Nothing

                    else
                        Just coord
            in
            ( { model
                | game =
                    { game
                        | pieceSelected = newPieceSelected
                    }
              }
            , Cmd.none
            )

        SetPieceSelected pieceSelected ->
            let
                { game } =
                    model
            in
            ( { model
                | game =
                    { game
                        | pieceSelected = pieceSelected
                    }
              }
            , Cmd.none
            )

        MakeMove movementType ->
            let
                { game } =
                    model
            in
            case movementType of
                MovementType.Capture capture ->
                    ( { model | game = Game.makeCapture game capture }
                    , Sound.play Capture.soundFilename
                    )

                MovementType.Move move ->
                    ( { model | game = Game.makeMove game move }
                    , Sound.play Move.soundFilename
                    )

        ReproduceSound soundFilename ->
            ( model, Sound.play soundFilename )
