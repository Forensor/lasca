module Main exposing (main)

import Board exposing (Board)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Orientation exposing (Orientation)
import Piece exposing (Piece)
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)


type Msg
    = UrlChange Url
    | UrlRequest UrlRequest


type Model
    = Redirect Session


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRoute (Route.fromUrl url) (Redirect (Session.default navKey))


modelToSession : Model -> Session
modelToSession model =
    case model of
        Redirect session ->
            session


changeRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRoute maybeRoute model =
    let
        session : Session
        session =
            modelToSession model
    in
    case maybeRoute of
        Nothing ->
            ( model, Cmd.none )

        Just Route.Home ->
            ( model, Cmd.none )

        Just (Route.Game _) ->
            ( model, Cmd.none )

        Just Route.Rules ->
            ( model, Cmd.none )

        Just Route.Analysis ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    let
        viewPage : Document Msg
        viewPage =
            case model of
                Redirect _ ->
                    { title = "lasca - Redirecting..."
                    , body =
                        []
                    }
    in
    viewPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( UrlChange url, _ ) ->
            changeRoute (Route.fromUrl url) model

        ( UrlRequest urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl
                        (modelToSession model
                            |> .navKey
                        )
                        (Url.toString url)
                    )

                Browser.External url ->
                    ( model, Nav.load url )


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
