module Page.Game exposing (Model, Msg, init, view)

import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes as Attrs
import Page
import Preferences
import Session exposing (Session)


type alias Model =
    { session : Session }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanel Preferences.PanelState


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "lasca - Game"
    , body =
        [ Page.viewHeader TogglePreferencesPanel
        ]
    }
