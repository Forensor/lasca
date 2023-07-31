module Game exposing (Game, defaultGame, view)

import Board exposing (Board)
import Capture exposing (Capture)
import Coord exposing (Coord)
import Counter exposing (Counter)
import Dict.Any as AnyDict
import Direction exposing (Direction)
import Html exposing (Html)
import Html.Attributes as Attrs
import List.NonEmpty as NonEmpty
import Move exposing (Move)
import Piece
import Set.Any as AnySet exposing (AnySet)
import Team exposing (Team)


type alias Game =
    { board : Board
    , turn : Team
    }


defaultGame : Game
defaultGame =
    { board = Board.defaultBoard
    , turn = Team.defaultTeam
    }


{-| Returns a `Capture` if possible, given the desired `Coord` and `Direction`.

For a `Capture` to be possible, these conditions need to be met:

  - Origin piece `Team` must belong to the current turn
  - Origin piece `Role` can move to the desired direction
  - Piece captured must belong to the opposite `Team`
  - Destination `Coord` must be unoccupied
  - Capturee `Coord` must not be excluded (i.e. it mustn't have been captured before)

-}
getMaybeCaptureByCoordAndDirection :
    Game
    -> AnySet String Coord
    -> Coord
    -> Direction
    -> Maybe Capture
getMaybeCaptureByCoordAndDirection game excludedCaptureeCoords coord direction =
    let
        maybeCaptureeCoord : Maybe Coord
        maybeCaptureeCoord =
            Coord.adjacentByDirection coord direction

        maybeDestinationCoord : Maybe Coord
        maybeDestinationCoord =
            maybeCaptureeCoord
                |> Maybe.andThen
                    (\captureeCoord ->
                        Coord.adjacentByDirection captureeCoord direction
                    )

        maybeOriginTopmostCounter : Maybe Counter
        maybeOriginTopmostCounter =
            AnyDict.get coord game.board
                |> Maybe.map NonEmpty.head

        originPieceBelongsToCurrentTurn : Bool
        originPieceBelongsToCurrentTurn =
            maybeOriginTopmostCounter
                |> Maybe.map (.team >> (==) game.turn)
                |> Maybe.withDefault False

        originPieceCanMoveToDesiredDirection : Bool
        originPieceCanMoveToDesiredDirection =
            maybeOriginTopmostCounter
                |> Maybe.andThen
                    (\originTopmostCounter ->
                        AnyDict.get direction Counter.directions
                            |> Maybe.map (AnySet.member originTopmostCounter)
                    )
                |> Maybe.withDefault False

        captureeBelongsToTheOppositeTeam : Bool
        captureeBelongsToTheOppositeTeam =
            maybeCaptureeCoord
                |> Maybe.andThen
                    (\captureeCoord ->
                        AnyDict.get captureeCoord game.board
                    )
                |> Maybe.map (Piece.team >> (/=) game.turn)
                |> Maybe.withDefault False

        destinationIsUnoccupied : Bool
        destinationIsUnoccupied =
            maybeDestinationCoord
                |> Maybe.andThen
                    (\destinationCoord ->
                        AnyDict.get destinationCoord game.board
                    )
                |> (==) Nothing

        captureeCoordIsNotExcluded : Bool
        captureeCoordIsNotExcluded =
            maybeCaptureeCoord
                |> Maybe.map
                    (\captureeCoord ->
                        AnySet.member captureeCoord excludedCaptureeCoords
                            |> not
                    )
                |> Maybe.withDefault False

        allCaptureConditionsAreMet : Bool
        allCaptureConditionsAreMet =
            List.all ((==) True)
                [ originPieceBelongsToCurrentTurn
                , originPieceCanMoveToDesiredDirection
                , captureeBelongsToTheOppositeTeam
                , destinationIsUnoccupied
                , captureeCoordIsNotExcluded
                ]
    in
    if allCaptureConditionsAreMet then
        Maybe.map2
            (\captureeCord destinationCoord ->
                { origin = coord
                , capturee = captureeCord
                , destination = destinationCoord
                }
            )
            maybeCaptureeCoord
            maybeDestinationCoord

    else
        Nothing


{-| Get all `Capture`s for every possible `Direction` on the desired `Coord`.
-}
getCapturesByCoord : Game -> AnySet String Coord -> Coord -> AnySet String Capture
getCapturesByCoord game excludedCaptureeCoords coord =
    AnySet.filterMap Capture.toString
        (getMaybeCaptureByCoordAndDirection game excludedCaptureeCoords coord)
        Direction.allDirections


{-| Get all the possible `Capture`s for the current turn.
-}
getAllPossibleCaptures : Game -> AnySet String Capture
getAllPossibleCaptures game =
    Coord.allCoords
        |> AnySet.toList
        |> List.concatMap
            (\coord ->
                getCapturesByCoord game (AnySet.empty Coord.toString) coord
                    |> AnySet.toList
            )
        |> AnySet.fromList Capture.toString


{-| Returns a `Move` if possible, given the desired `Coord` and `Direction`.

For a `Move` to be possible, these conditions need to be met:

  - Origin piece `Team` must belong to the current turn
  - Origin piece `Role` can move to the desired direction
  - Destination `Coord` must be unoccupied

-}
getMaybeMoveByCoordAndDirection :
    Game
    -> Coord
    -> Direction
    -> Maybe Move
getMaybeMoveByCoordAndDirection game coord direction =
    let
        maybeDestinationCoord : Maybe Coord
        maybeDestinationCoord =
            Coord.adjacentByDirection coord direction

        maybeOriginTopmostCounter : Maybe Counter
        maybeOriginTopmostCounter =
            AnyDict.get coord game.board
                |> Maybe.map NonEmpty.head

        originPieceBelongsToCurrentTurn : Bool
        originPieceBelongsToCurrentTurn =
            maybeOriginTopmostCounter
                |> Maybe.map (.team >> (==) game.turn)
                |> Maybe.withDefault False

        originPieceCanMoveToDesiredDirection : Bool
        originPieceCanMoveToDesiredDirection =
            maybeOriginTopmostCounter
                |> Maybe.andThen
                    (\originTopmostCounter ->
                        AnyDict.get direction Counter.directions
                            |> Maybe.map (AnySet.member originTopmostCounter)
                    )
                |> Maybe.withDefault False

        destinationIsUnoccupied : Bool
        destinationIsUnoccupied =
            maybeDestinationCoord
                |> Maybe.andThen
                    (\destinationCoord ->
                        AnyDict.get destinationCoord game.board
                    )
                |> (==) Nothing

        allMoveConditionsAreMet : Bool
        allMoveConditionsAreMet =
            List.all ((==) True)
                [ originPieceBelongsToCurrentTurn
                , originPieceCanMoveToDesiredDirection
                , destinationIsUnoccupied
                ]
    in
    if allMoveConditionsAreMet then
        Maybe.map
            (\destinationCoord ->
                { origin = coord
                , destination = destinationCoord
                }
            )
            maybeDestinationCoord

    else
        Nothing


{-| Get all `Move`s for every possible `Direction` on the desired `Coord`.
-}
getMovesByCoord : Game -> Coord -> AnySet String Move
getMovesByCoord game coord =
    AnySet.filterMap Move.toString
        (getMaybeMoveByCoordAndDirection game coord)
        Direction.allDirections


view : Game -> Html msg
view game =
    Html.node "game"
        [ Attrs.class "game block" ]
        [ Board.view game.board ]
