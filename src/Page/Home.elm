module Page.Home exposing (..)

import Browser exposing (Document)
import Html exposing (Html)
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
    { title = "lasca"
    , body =
        [ Page.viewHeader
        , Html.text "Page.Home"
        ]
    }
