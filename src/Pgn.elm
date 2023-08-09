module Pgn exposing (Pgn, fromGame, toString)

import Game exposing (Game)
import Movement exposing (Movement)


type Pgn
    = Pgn String


fromGame : Game -> Pgn
fromGame { movementHistory } =
    fromGameHelp movementHistory 1
        |> String.join " "
        |> Pgn


fromGameHelp : List Movement -> Int -> List String
fromGameHelp movements fullMoveNumber =
    case movements of
        [] ->
            []

        _ ->
            (List.take 2 movements
                |> List.map Movement.toString
                |> (\movementsSans ->
                        String.join " "
                            ((String.fromInt fullMoveNumber ++ ".") :: movementsSans)
                   )
            )
                :: fromGameHelp (List.drop 2 movements) (fullMoveNumber + 1)


toString : Pgn -> String
toString (Pgn pgn) =
    pgn
