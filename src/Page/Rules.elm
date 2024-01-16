module Page.Rules exposing (Model, Msg, init, update, view)

import Browser exposing (Document)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Page
import Preferences
import Session exposing (Session)


type alias Model =
    { session : Session
    , preferencesPanelIsOpen : Bool
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanelIsOpened Bool


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , preferencesPanelIsOpen = False
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
    [ Html.div
        [ Attrs.class "h-screen" ]
        [ Page.viewHeader TogglePreferencesPanel
        , Page.viewIf
            model.preferencesPanelIsOpen
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
                newPreferencesPanelIsOpened : Bool
                newPreferencesPanelIsOpened =
                    not model.preferencesPanelIsOpen
            in
            ( { model
                | preferencesPanelIsOpen = newPreferencesPanelIsOpened
              }
            , Cmd.none
            )

        SetPreferencesPanelIsOpened preferencesPanelIsOpen ->
            ( { model
                | preferencesPanelIsOpen = preferencesPanelIsOpen
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.preferencesPanelIsOpen then
            Page.mouseDownOutsideElementIdsEvent
                (SetPreferencesPanelIsOpened False)
                [ Preferences.dropdownId, Preferences.gearButtonId ]

          else
            Sub.none
        ]
