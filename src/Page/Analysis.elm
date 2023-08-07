module Page.Analysis exposing (..)

import Board exposing (Board)
import Browser exposing (Document)
import Capture exposing (Capture)
import Coord exposing (Coord)
import Game exposing (Game)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Move exposing (Move)
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
    , preferencesPanelIsOpened : Bool
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanelIsOpened Bool
    | EnlargeBoardSize
    | ReduceBoardSize
    | SwapBoardOrientation
    | ReproduceSound String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , game = Game.defaultGame
      , preferencesPanelIsOpened = False
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
            if model.preferencesPanelIsOpened then
                [ Page.clickOutsideElementIdsEvent
                    (SetPreferencesPanelIsOpened False)
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
            model.preferencesPanelIsOpened
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
            }
            model.game.board
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )

        TogglePreferencesPanel ->
            let
                newPreferencesPanelIsOpened : Bool
                newPreferencesPanelIsOpened =
                    not model.preferencesPanelIsOpened
            in
            ( { model
                | preferencesPanelIsOpened = newPreferencesPanelIsOpened
              }
            , Cmd.none
            )

        SetPreferencesPanelIsOpened preferencesPanelIsOpened ->
            ( { model
                | preferencesPanelIsOpened = preferencesPanelIsOpened
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
