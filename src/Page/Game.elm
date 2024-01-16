module Page.Game exposing (Model, Msg, init, view)

import Browser exposing (Document)
import Coord exposing (Coord)
import Fen exposing (Fen)
import Game
import Html exposing (Html)
import Html.Attributes as Attrs
import Move exposing (Move)
import Movement exposing (Movement)
import Page
import Pgn exposing (Pgn)
import Preferences
import Session exposing (Session)


type alias Model =
    { session : Session }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanelIsOpened Bool


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "lasca - Game"
    , body =
        [ Page.viewHeader TogglePreferencesPanel
        , Game.default |> Fen.fromGame |> Fen.toString |> Html.text
        , Html.text "Page.Game"
        ]
    }
