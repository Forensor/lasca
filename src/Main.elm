module Main exposing (main)

import Board exposing (Board)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Html
import Orientation exposing (Orientation)
import Page.Analysis
import Page.Game
import Page.Home
import Page.Rules
import Piece exposing (Piece)
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)


type Msg
    = UrlChange Url
    | UrlRequest UrlRequest
    | HomeMsg Page.Home.Msg
    | GameMsg Page.Game.Msg
    | RulesMsg Page.Rules.Msg
    | AnalysisMsg Page.Analysis.Msg


type Model
    = Home Page.Home.Model
    | Game Page.Game.Model
    | Rules Page.Rules.Model
    | Analysis Page.Analysis.Model
    | Redirect Session


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    changeRoute (Route.fromUrl url) (Redirect (Session.default navKey))


modelToSession : Model -> Session
modelToSession model =
    case model of
        Home { session } ->
            session

        Game { session } ->
            session

        Rules { session } ->
            session

        Analysis { session } ->
            session

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
            Page.Home.init session
                |> Tuple.mapBoth Home (Cmd.map HomeMsg)

        Just (Route.Game _) ->
            Page.Game.init session
                |> Tuple.mapBoth Game (Cmd.map GameMsg)

        Just Route.Rules ->
            Page.Rules.init session
                |> Tuple.mapBoth Rules (Cmd.map RulesMsg)

        Just Route.Analysis ->
            Page.Analysis.init session
                |> Tuple.mapBoth Analysis (Cmd.map AnalysisMsg)


view : Model -> Document Msg
view model =
    let
        viewPage : Document Msg
        viewPage =
            case model of
                Home homeModel ->
                    let
                        { title, body } =
                            Page.Home.view homeModel
                    in
                    { title = title
                    , body = List.map (Html.map HomeMsg) body
                    }

                Game gameModel ->
                    let
                        { title, body } =
                            Page.Game.view gameModel
                    in
                    { title = title
                    , body = List.map (Html.map GameMsg) body
                    }

                Rules rulesModel ->
                    let
                        { title, body } =
                            Page.Rules.view rulesModel
                    in
                    { title = title
                    , body = List.map (Html.map RulesMsg) body
                    }

                Analysis analysisModel ->
                    let
                        { title, body } =
                            Page.Analysis.view analysisModel
                    in
                    { title = title
                    , body = List.map (Html.map AnalysisMsg) body
                    }

                Redirect _ ->
                    { title = "lasca - Redirecting..."
                    , body = []
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

        ( HomeMsg homeMsg, Home homeModel ) ->
            Page.Home.update homeMsg homeModel
                |> Tuple.mapBoth Home (Cmd.map HomeMsg)

        ( RulesMsg rulesMsg, Rules rulesModel ) ->
            Page.Rules.update rulesMsg rulesModel
                |> Tuple.mapBoth Rules (Cmd.map RulesMsg)

        ( AnalysisMsg analysisMsg, Analysis analysisModel ) ->
            Page.Analysis.update analysisMsg analysisModel
                |> Tuple.mapBoth Analysis (Cmd.map AnalysisMsg)

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        Home homeModel ->
            Sub.none

        Game gameModel ->
            Sub.none

        Rules rulesModel ->
            Sub.none

        Analysis analysisModel ->
            Page.Analysis.subscriptions analysisModel
                |> Sub.map AnalysisMsg

        Redirect _ ->
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
