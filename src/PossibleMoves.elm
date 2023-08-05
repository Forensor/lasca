module PossibleMoves exposing (..)

import Capture exposing (Capture)
import Coord exposing (Coord)
import Move exposing (Move)
import Set.Any as AnySet exposing (AnySet)


type PossibleMoves
    = Captures (AnySet String Capture)
    | Moves (AnySet String Move)
    | None


filterByOriginAndDestinationCoords : Coord -> Coord -> PossibleMoves -> PossibleMoves
filterByOriginAndDestinationCoords origin destination possibleMoves =
    case possibleMoves of
        Captures captures ->
            captures
                |> AnySet.filter
                    (\capture ->
                        capture.origin == origin && capture.destination == destination
                    )
                |> Captures

        Moves moves ->
            moves
                |> AnySet.filter
                    (\move ->
                        move.origin == origin && move.destination == destination
                    )
                |> Moves

        None ->
            None
