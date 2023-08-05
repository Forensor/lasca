module Page.Rules exposing (Model, Msg, init, update, view)

import Browser exposing (Document)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Page
import Preferences
import Session exposing (Session)


type alias Model =
    { session : Session
    , preferencesPanelState : Preferences.PanelState
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanel Preferences.PanelState


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , preferencesPanelState = Preferences.Closed
      }
    , Cmd.none
    )


view : Model -> Document Msg
view model =
    { title = "lasca - Rules"
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
                { enlargeBoardSizeButtonMsg =
                    NoOp "Ignoring enlarge board size change in Rules page"
                , reduceBoardSizeButtonMsg =
                    NoOp "Ignoring reduce board size change in Rules page"
                , swapBoardOrientationMsg =
                    NoOp "Ignoring swap board orientation change in Rules page"
                }
            )
        , viewContent model
        ]
    ]


viewContent : Model -> Html Msg
viewContent model =
    Html.div [] [ Html.text "Page.Rules" ]


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
