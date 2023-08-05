module Page.Home exposing (..)

import Browser exposing (Document)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Page
import Preferences exposing (Preferences)
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
    { title = "lasca"
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
                    NoOp "Ignoring enlarge board size change in Home page"
                , reduceBoardSizeButtonMsg =
                    NoOp "Ignoring reduce board size change in Home page"
                , swapBoardOrientationMsg =
                    NoOp "Ignoring swap board orientation change in Home page"
                }
            )
        , viewContent model
        ]
    ]


viewContent : Model -> Html Msg
viewContent model =
    let
        buttonClasses : Attribute Msg
        buttonClasses =
            Attrs.class <|
                String.join " "
                    [ "rounded-[4px]"
                    , "bg-gunmetal"
                    , "text-white"
                    , "p-[16px]"
                    , "hover:opacity-50"
                    , "transition-opacity"
                    , "duration-200"
                    ]
    in
    Html.div
        [ Attrs.class "flex justify-center pt-[100px]"
        ]
        [ Html.main_ [ Attrs.class "flex flex-col gap-[10px]" ]
            [ Html.button
                [ buttonClasses
                , Attrs.attribute "aria-label" "matchmaking"
                ]
                [ Html.text "ENTER MATCHMAKING" ]
            , Html.button
                [ buttonClasses
                , Attrs.attribute "aria-label" "play"
                ]
                [ Html.text "PLAY AGAINST A FRIEND" ]
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
