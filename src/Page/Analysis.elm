module Page.Analysis exposing (..)

import Board exposing (Board)
import Browser exposing (Document)
import Game exposing (Game)
import Html exposing (Html)
import Html.Attributes as Attrs
import Page
import Piece exposing (Piece)
import Session exposing (Session)
import Team exposing (Team)


type alias Model =
    { session : Session
    , game : Game
    }


type Msg
    = NoOp String
    | BoardMsg Board.Msg


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , game = Game.defaultGame
      }
    , Cmd.none
    )


view : Model -> Document Msg
view model =
    { title = "lasca - Analysis"
    , body =
        [ Page.viewHeader
        , viewContent model
        ]
    }


viewContent : Model -> Html Msg
viewContent model =
    Html.div [ Attrs.class "mt-[100px] flex justify-center" ]
        [ viewAnalysisPanel model ]


viewAnalysisPanel : Model -> Html Msg
viewAnalysisPanel model =
    Html.main_ [ Attrs.class "flex flex-col" ]
        [ Board.view
            { pieceSize = model.session.preferences.pieceSize }
            model.game.board
            |> Html.map BoardMsg
        , Html.div [] [ Html.text <| Team.toString model.game.turn ++ "'s turn" ]
        ]
