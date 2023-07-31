module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Game
import Url exposing (Url)


type Msg
    = NoOp String
    | UrlChange Url
    | UrlRequest UrlRequest


type alias Model =
    {}


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( {}, Cmd.none )


view : Model -> Document Msg
view _ =
    { title = "lasca"
    , body =
        [ Game.view
            Game.defaultGame
        ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )

        UrlChange _ ->
            ( model, Cmd.none )

        UrlRequest _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChange
        , onUrlRequest = UrlRequest
        }
