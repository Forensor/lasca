module Game exposing
    ( Game
    , default
    , getAllPossibleCaptureSteps
    , getAllPossibleMoves
    , getMovesByCoord
    , makeMovement
    )

import Board exposing (Board)
import Capture exposing (Capture)
import CaptureStep exposing (CaptureStep)
import Coord exposing (Coord)
import Counter exposing (Counter)
import Dict.Any as AnyDict
import Direction exposing (Direction)
import List.NonEmpty as NonEmpty
import Move exposing (Move)
import Movement exposing (Movement)
import Piece exposing (Piece)
import PossibleMoves exposing (PossibleMoves)
import Set.Any as AnySet exposing (AnySet)
import Team exposing (Team)


{-| A record representing the model of a `Game`.

`movementHistory` does not include the current `Fen` of the turn.

-}
type alias Game =
    { board : Board
    , turn : Team
    , possibleMoves : PossibleMoves
    , excludedCaptures : AnySet Int Coord
    , movementHistory : List Movement
    }


default : Game
default =
    { board = Board.default
    , turn = Team.default
    , possibleMoves =
        PossibleMoves.Moves
            (AnySet.fromList Move.toString
                [ { origin = Coord.S8, destination = Coord.S12 }
                , { origin = Coord.S9, destination = Coord.S12 }
                , { origin = Coord.S9, destination = Coord.S13 }
                , { origin = Coord.S10, destination = Coord.S13 }
                , { origin = Coord.S10, destination = Coord.S14 }
                , { origin = Coord.S11, destination = Coord.S14 }
                ]
            )
    , excludedCaptures = AnySet.empty Coord.toInt
    , movementHistory = []
    }


{-| Returns a `Capture` if possible, given the desired `Coord` and `Direction`.

For a `Capture` to be possible, these conditions need to be met:

  - Origin piece `Team` must belong to the current turn
  - Origin piece `Role` can move to the desired direction
  - Piece captured must belong to the opposite `Team`
  - Destination `Coord` must be unoccupied
  - Capturee `Coord` must not be excluded (i.e. it mustn't have been captured before)

-}
getMaybeCaptureStepByCoordAndDirection :
    Game
    -> Coord
    -> Direction
    -> Maybe CaptureStep
getMaybeCaptureStepByCoordAndDirection game coord direction =
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
                |> Maybe.map Piece.getTopmostCounter

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
                        AnySet.member captureeCoord game.excludedCaptures
                            |> not
                    )
                |> Maybe.withDefault False

        allCaptureStepConditionsAreMet : Bool
        allCaptureStepConditionsAreMet =
            List.all ((==) True)
                [ originPieceBelongsToCurrentTurn
                , originPieceCanMoveToDesiredDirection
                , captureeBelongsToTheOppositeTeam
                , destinationIsUnoccupied
                , captureeCoordIsNotExcluded
                ]
    in
    if allCaptureStepConditionsAreMet then
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
getCaptureStepsByCoord : Game -> Coord -> AnySet String CaptureStep
getCaptureStepsByCoord game coord =
    AnySet.filterMap CaptureStep.toString
        (getMaybeCaptureStepByCoordAndDirection game coord)
        Direction.allDirections


{-| Get all the possible `Capture`s for the current turn.
-}
getAllPossibleCaptureSteps : Game -> AnySet String CaptureStep
getAllPossibleCaptureSteps game =
    Coord.allCoords
        |> AnySet.toList
        |> List.concatMap
            (\coord ->
                getCaptureStepsByCoord game coord
                    |> AnySet.toList
            )
        |> AnySet.fromList CaptureStep.toString


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
                |> Maybe.map Piece.getTopmostCounter

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


{-| Get all the possible `Move`s for the current turn.
-}
getAllPossibleMoves : Game -> AnySet String Move
getAllPossibleMoves game =
    Coord.allCoords
        |> AnySet.toList
        |> List.concatMap
            (\coord ->
                getMovesByCoord game coord
                    |> AnySet.toList
            )
        |> AnySet.fromList Move.toString


makeMove : Game -> Move -> Game
makeMove game move =
    let
        maybeOriginPiece : Maybe Piece
        maybeOriginPiece =
            AnyDict.get move.origin game.board
    in
    case maybeOriginPiece of
        Just piece ->
            let
                newBoard : Board
                newBoard =
                    AnyDict.remove move.origin game.board
                        |> AnyDict.insert move.destination
                            piece

                newTurn : Team
                newTurn =
                    Team.opposite game.turn

                newPossibleMoves : PossibleMoves
                newPossibleMoves =
                    let
                        possibleCaptureSteps : AnySet String CaptureStep
                        possibleCaptureSteps =
                            getAllPossibleCaptureSteps
                                { game
                                    | board = newBoard
                                    , turn = newTurn
                                }

                        possibleMoves : AnySet String Move
                        possibleMoves =
                            getAllPossibleMoves
                                { game
                                    | board = newBoard
                                    , turn = newTurn
                                }
                    in
                    if AnySet.size possibleCaptureSteps > 0 then
                        PossibleMoves.Captures possibleCaptureSteps

                    else if AnySet.size possibleMoves > 0 then
                        PossibleMoves.Moves possibleMoves

                    else
                        PossibleMoves.None
            in
            { game
                | board = newBoard
                , turn = newTurn
                , possibleMoves = newPossibleMoves
                , excludedCaptures = AnySet.empty Coord.toInt
            }
                |> promoteLastRowsToOfficers

        Nothing ->
            game


makeCaptureStep : Game -> CaptureStep -> Game
makeCaptureStep game capture =
    let
        maybeOriginPiece : Maybe Piece
        maybeOriginPiece =
            AnyDict.get capture.origin game.board

        maybeCaptureePiece : Maybe Piece
        maybeCaptureePiece =
            AnyDict.get capture.capturee game.board
    in
    case ( maybeOriginPiece, maybeCaptureePiece ) of
        ( Just originPiece, Just capturedPiece ) ->
            let
                newCapturedPiece : Maybe Piece
                newCapturedPiece =
                    NonEmpty.dropHead capturedPiece

                destinationPiece : Piece
                destinationPiece =
                    NonEmpty.append originPiece
                        (NonEmpty.singleton <|
                            NonEmpty.head capturedPiece
                        )

                insertOrRemoveNewCapturedPiece : Board -> Board
                insertOrRemoveNewCapturedPiece =
                    case newCapturedPiece of
                        Just piece ->
                            AnyDict.insert capture.capturee piece

                        Nothing ->
                            AnyDict.remove capture.capturee

                newBoard : Board
                newBoard =
                    AnyDict.remove capture.origin game.board
                        |> insertOrRemoveNewCapturedPiece
                        |> AnyDict.insert capture.destination destinationPiece

                possibleFurtherCaptureSteps : AnySet String CaptureStep
                possibleFurtherCaptureSteps =
                    getCaptureStepsByCoord
                        { game
                            | board = newBoard
                            , turn = game.turn
                            , excludedCaptures =
                                game.excludedCaptures
                                    |> AnySet.insert capture.capturee
                        }
                        capture.destination

                newExcludedCaptures : AnySet Int Coord
                newExcludedCaptures =
                    if AnySet.size possibleFurtherCaptureSteps > 0 then
                        game.excludedCaptures
                            |> AnySet.insert capture.capturee

                    else
                        AnySet.empty Coord.toInt

                newTurn : Team
                newTurn =
                    if AnySet.size possibleFurtherCaptureSteps > 0 then
                        game.turn

                    else
                        Team.opposite game.turn

                newPossibleMoves : PossibleMoves
                newPossibleMoves =
                    let
                        possibleCaptureSteps : AnySet String CaptureStep
                        possibleCaptureSteps =
                            getAllPossibleCaptureSteps
                                { game
                                    | board = newBoard
                                    , turn = newTurn
                                }

                        possibleMoves : AnySet String Move
                        possibleMoves =
                            getAllPossibleMoves
                                { game
                                    | board = newBoard
                                    , turn = newTurn
                                }
                    in
                    if AnySet.size possibleFurtherCaptureSteps > 0 then
                        PossibleMoves.Captures possibleFurtherCaptureSteps

                    else if AnySet.size possibleCaptureSteps > 0 then
                        PossibleMoves.Captures possibleCaptureSteps

                    else if AnySet.size possibleMoves > 0 then
                        PossibleMoves.Moves possibleMoves

                    else
                        PossibleMoves.None
            in
            { game
                | board = newBoard
                , turn = newTurn
                , possibleMoves = newPossibleMoves
                , excludedCaptures = newExcludedCaptures
            }
                |> promoteLastRowsToOfficers

        _ ->
            game


makeCapture : Game -> Capture -> Game
makeCapture game capture =
    NonEmpty.foldl
        (\captureStep game_ ->
            makeCaptureStep game_ captureStep
        )
        game
        capture


makeMovement : Game -> Movement -> Game
makeMovement game movement =
    case movement of
        Movement.Capture capture ->
            makeCapture game capture
                |> addMovementToHistory movement

        Movement.Move move ->
            makeMove game move
                |> addMovementToHistory movement


addMovementToHistory : Movement -> Game -> Game
addMovementToHistory movement game =
    { game
        | movementHistory = game.movementHistory ++ [ movement ]
    }


promoteLastRowsToOfficers : Game -> Game
promoteLastRowsToOfficers game =
    let
        lastWhiteRows : List Coord
        lastWhiteRows =
            [ Coord.S22, Coord.S23, Coord.S24, Coord.S25 ]

        lastBlackRows : List Coord
        lastBlackRows =
            [ Coord.S1, Coord.S2, Coord.S3, Coord.S4 ]

        newBoard : Board
        newBoard =
            List.map2
                (\lastWhiteRow lastBlackRow ->
                    [ ( lastWhiteRow
                      , AnyDict.get lastWhiteRow game.board
                            |> Maybe.map (Piece.convertToOfficerByTeam Team.White)
                      )
                    , ( lastBlackRow
                      , AnyDict.get lastBlackRow game.board
                            |> Maybe.map (Piece.convertToOfficerByTeam Team.Black)
                      )
                    ]
                )
                lastWhiteRows
                lastBlackRows
                |> List.concat
                |> List.concatMap
                    (\( coord, maybePiece ) ->
                        case maybePiece of
                            Just piece ->
                                [ ( coord, piece ) ]

                            Nothing ->
                                []
                    )
                |> List.foldl
                    (\( coord, piece ) board ->
                        AnyDict.insert coord piece board
                    )
                    game.board
    in
    { game | board = newBoard }


currentTurnHasNoPieces : Game -> Bool
currentTurnHasNoPieces game =
    game.board
        |> AnyDict.values
        |> List.filter (Piece.team >> (==) game.turn)
        |> (\piecesFiltered -> List.length piecesFiltered == 0)
