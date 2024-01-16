module Fen exposing (Fen, fromGame, toString)

import Board exposing (Board)
import Coord exposing (Coord)
import Dict.Any as AnyDict
import Game exposing (Game)
import Movement exposing (Movement)
import Piece
import Set.Any as AnySet exposing (AnySet)
import Team exposing (Team)


type Fen
    = Fen String


generateBoardPart : Board -> String
generateBoardPart board =
    generateBoardPartHelp board Coord.allCoordsForFen 4
        |> String.join "/"


generateBoardPartHelp : Board -> List Coord -> Int -> List String
generateBoardPartHelp board coords squaresInRow =
    case coords of
        [] ->
            []

        _ ->
            let
                rowCoords : List Coord
                rowCoords =
                    List.take squaresInRow coords

                newCoords : List Coord
                newCoords =
                    List.drop squaresInRow coords

                newSquaresInRow : Int
                newSquaresInRow =
                    if squaresInRow == 4 then
                        3

                    else
                        4
            in
            (List.map (\coord -> AnyDict.get coord board) rowCoords
                |> List.map (Maybe.map Piece.toString >> Maybe.withDefault "")
                |> String.join ","
            )
                :: generateBoardPartHelp board newCoords newSquaresInRow


generateTurnPart : Team -> String
generateTurnPart =
    Team.toString
        >> String.left 1
        >> String.toLower


generateFullMovesPart : List Movement -> String
generateFullMovesPart movements =
    List.length movements
        // 2
        |> String.fromInt


fromGame : Game -> Fen
fromGame game =
    String.join " "
        [ generateBoardPart game.board
        , generateTurnPart game.turn
        , generateFullMovesPart game.movementHistory
        ]
        |> Fen


{-| Unwrap the `Fen` into a raw `String`.

Use it sparingly.

-}
toString : Fen -> String
toString (Fen fen) =
    fen
