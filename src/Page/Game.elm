module Page.Game exposing (Model, Msg, init, view)

import Browser exposing (Document)
import Html exposing (Html)
import Html.Attributes as Attrs
import Page
import Session exposing (Session)


type alias Model =
    { session : Session }


type Msg
    = NoOp String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "lasca - Game"
    , body =
        [ Page.viewHeader ]
    }
