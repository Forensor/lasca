module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Html exposing (Html)
import Html.Attributes as Attrs
import Url exposing (Url)


type Msg
    = NoOp
    | UrlChange Url
    | UrlRequest UrlRequest


type alias Model =
    {}


init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( {}, Cmd.none )


viewQuickstartButton : String -> Html Msg
viewQuickstartButton mode =
    Html.button
        [ Attrs.class "bg-columbia-blue/10 hover:bg-columbia-blue text-5xl transition-colors ease-in-out duration-300 rounded-[4px] border-2 border-columbia-blue/50 text-dark-electric-blue" ]
        [ Html.text mode ]


viewHome : Html Msg
viewHome =
    let
        quickstartModes : List String
        quickstartModes =
            [ "1+0"
            , "2+1"
            , "3+0"
            , "3+2"
            , "5+0"
            , "5+3"
            , "10+0"
            , "10+5"
            , "15+10"
            , "30+0"
            , "30+20"
            , "60+30"
            ]
    in
    Html.div
        [ Attrs.class "h-screen font-raleway" ]
        [ viewHeader
        , Html.main_
            [ Attrs.class "flex items-center justify-center h-[calc(100%-56px)] gap-x-[50px]" ]
            [ Html.div
                [ Attrs.class "w-[750px] h-[750px] mb-[50px]" ]
                [ Html.div
                    [ Attrs.class "h-[50px] grid grid-cols-2" ]
                    [ Html.button
                        [ Attrs.class "text-cerulean-frost border-b-2 border-cerulean-frost font-bold" ]
                        [ Html.text "Quickstart" ]
                    , Html.button
                        [ Attrs.class "hover:text-cerulean-frost transition-colors ease-in-out duration-300" ]
                        [ Html.text "Rooms" ]
                    ]
                , Html.div
                    [ Attrs.class "grid grid-cols-3 grid-rows-4 h-[calc(100%-50px)] gap-3 shadow-md shadow-gray-300/50 bg-white p-3 rounded-[4px]" ]
                  <|
                    List.map
                        viewQuickstartButton
                        quickstartModes
                ]
            , Html.div
                [ Attrs.class "w-[350px] h-[160px] flex flex-col gap-y-[20px]" ]
                [ Html.button
                    [ Attrs.class "w-full h-[40px] bg-dark-electric-blue text-columbia-blue rounded-[4px] hover:opacity-75 transition-opacity ease-in-out duration-300" ]
                    [ Html.text "CREATE A ROOM" ]
                , Html.button
                    [ Attrs.class "w-full h-[40px] bg-dark-electric-blue text-columbia-blue rounded-[4px] hover:opacity-75 transition-opacity ease-in-out duration-300" ]
                    [ Html.text "PLAY AGAINST A FRIEND" ]
                , Html.button
                    [ Attrs.class "w-full h-[40px] bg-dark-electric-blue text-columbia-blue rounded-[4px] hover:opacity-75 transition-opacity ease-in-out duration-300" ]
                    [ Html.text "PLAY LOCALLY" ]
                ]
            ]
        ]


viewHeader : Html Msg
viewHeader =
    Html.header
        [ Attrs.class "h-[56px] bg-gradient-to-b from-gray-300 to-white flex items-center justify-center" ]
        [ Html.nav
            [ Attrs.class "flex h-[40px] w-[1200px] gap-x-[20px] items-center" ]
            [ Html.a
                [ Attrs.href "/"
                , Attrs.class "text-3xl w-[80px] h-[40px] hover:opacity-50 transition-opacity ease-in-out duration-300 font-bold"
                ]
                [ Html.text "lasca" ]
            , Html.a
                [ Attrs.href "/"
                , Attrs.class "hover:text-cerulean-frost"
                ]
                [ Html.text "PLAY" ]
            , Html.a
                [ Attrs.href "/rules"
                , Attrs.class "hover:text-cerulean-frost"
                ]
                [ Html.text "LEARN" ]
            , Html.a
                [ Attrs.href "/watch"
                , Attrs.class "hover:text-cerulean-frost"
                ]
                [ Html.text "WATCH" ]
            ]
        ]


viewRules : Html Msg
viewRules =
    Html.div
        [ Attrs.class "h-screen font-raleway" ]
        [ viewHeader
        , Html.main_
            [ Attrs.class "flex items-center justify-center h-[calc(100%-56px-20px)] mt-[20px]" ]
            [ Html.div
                [ Attrs.class "h-full w-[900px] break-words" ]
                [ Html.h1
                    [ Attrs.class "text-4xl font-bold" ]
                    [ Html.text "What is Lasca?" ]
                , Html.p
                    [ Attrs.class "mt-[8px] leading-7" ]
                    [ Html.text "Lasca is a draughts variant, invented by the second World Chess Champion Emanuel Lasker. Is derived from English draughts and the Russian draughts game bashni. The game is played on a 7x7 board alternating squares. The objective of the game is to leave the opponent without pieces or legal moves." ]
                ]
            ]
        ]


viewGame : Html Msg
viewGame =
    Html.div
        [ Attrs.class "h-screen font-raleway" ]
        [ viewHeader
        , Html.main_
            [ Attrs.class "flex justify-center h-[calc(100%-56px-50px)] mt-[50px] gap-[20px]" ]
            [ Html.div
                [ Attrs.class "w-[400px] h-[200px] shadow-md shadow-gray-300/50 bg-white" ]
                []
            , Html.div
                [ Attrs.class "w-[770px] h-[770px] shadow-md shadow-gray-300/50 bg-slate-500" ]
                []
            , Html.div
                [ Attrs.class "w-[400px] h-[350px] shadow-md shadow-gray-300/50 bg-white mt-[210px]" ]
                []
            ]
        ]


viewNotFound : Html Msg
viewNotFound =
    Html.div
        [ Attrs.class "h-screen font-raleway" ]
        [ viewHeader
        , Html.main_
            [ Attrs.class "flex items-center justify-center h-[calc(100%-56px)]" ]
            [ Html.div
                [ Attrs.class "h-[404px] w-[404px] break-words text-center" ]
                [ Html.h1
                    [ Attrs.class "text-4xl font-bold text-gray-500" ]
                    [ Html.text "PAGE NOT FOUND" ]
                , Html.p
                    [ Attrs.class "mt-[8px] leading-7" ]
                    [ Html.text "Return to ", Html.a [ Attrs.href "/", Attrs.class "text-cerulean-frost" ] [ Html.text "homepage" ], Html.text "?" ]
                ]
            ]
        ]


view : Model -> Document Msg
view _ =
    { title = "lasca"
    , body = [ viewGame ]
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
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
