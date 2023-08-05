module Game exposing
    ( Game
    , defaultGame
    , getAllPossibleCaptures
    , getAllPossibleMoves
    , getMoveDestinationCoordsByCoord
    , getMovesByCoord
    , makeCapture
    , makeMove
    , promoteLastRowsToOfficers
    )

import Board exposing (Board)
import Capture exposing (Capture)
import Coord exposing (Coord)
import Counter exposing (Counter)
import Dict.Any as AnyDict
import Direction exposing (Direction)
import Html exposing (Html)
import List.NonEmpty as NonEmpty
import Move exposing (Move)
import Piece exposing (Piece)
import PossibleMoves exposing (PossibleMoves)
import Set.Any as AnySet exposing (AnySet)
import Team exposing (Team)


type alias Game =
    { board : Board
    , turn : Team
    , pieceSelected : Maybe Coord
    , possibleMoves : PossibleMoves
    , excludedCaptures : AnySet String Coord
    }


type alias ShortGame =
    { board : Board
    , turn : Team
    }


defaultGame : Game
defaultGame =
    { board = Board.defaultBoard
    , turn = Team.defaultTeam
    , pieceSelected = Nothing
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
    , excludedCaptures = AnySet.empty Coord.toString
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
    ShortGame
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
getCapturesByCoord : ShortGame -> AnySet String Coord -> Coord -> AnySet String Capture
getCapturesByCoord game excludedCaptureeCoords coord =
    AnySet.filterMap Capture.toString
        (getMaybeCaptureByCoordAndDirection game excludedCaptureeCoords coord)
        Direction.allDirections


{-| Get all the possible `Capture`s for the current turn.
-}
getAllPossibleCaptures : ShortGame -> AnySet String Capture
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
    ShortGame
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
getMovesByCoord : ShortGame -> Coord -> AnySet String Move
getMovesByCoord game coord =
    AnySet.filterMap Move.toString
        (getMaybeMoveByCoordAndDirection game coord)
        Direction.allDirections


{-| Get all the possible `Move`s for the current turn.
-}
getAllPossibleMoves : ShortGame -> AnySet String Move
getAllPossibleMoves game =
    Coord.allCoords
        |> AnySet.toList
        |> List.concatMap
            (\coord ->
                getMovesByCoord game coord
                    |> AnySet.toList
            )
        |> AnySet.fromList Move.toString


getMoveDestinationCoordsByCoord : Game -> Coord -> AnySet String Coord
getMoveDestinationCoordsByCoord game coord =
    case game.possibleMoves of
        PossibleMoves.Captures captures ->
            AnySet.filter (.origin >> (==) coord) captures
                |> AnySet.map Coord.toString .destination

        PossibleMoves.Moves moves ->
            AnySet.filter (.origin >> (==) coord) moves
                |> AnySet.map Coord.toString .destination

        PossibleMoves.None ->
            AnySet.empty Coord.toString


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
                        possibleCaptures : AnySet String Capture
                        possibleCaptures =
                            getAllPossibleCaptures { board = newBoard, turn = newTurn }

                        possibleMoves : AnySet String Move
                        possibleMoves =
                            getAllPossibleMoves { board = newBoard, turn = newTurn }
                    in
                    if AnySet.size possibleCaptures > 0 then
                        PossibleMoves.Captures possibleCaptures

                    else if AnySet.size possibleMoves > 0 then
                        PossibleMoves.Moves possibleMoves

                    else
                        PossibleMoves.None
            in
            { board = newBoard
            , turn = newTurn
            , pieceSelected = Nothing
            , possibleMoves = newPossibleMoves
            , excludedCaptures = AnySet.empty Coord.toString
            }
                |> promoteLastRowsToOfficers

        Nothing ->
            game


makeCapture : Game -> Capture -> Game
makeCapture game capture =
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

                possibleFurtherCaptures : AnySet String Capture
                possibleFurtherCaptures =
                    let
                        excludedCaptures : AnySet String Coord
                        excludedCaptures =
                            game.excludedCaptures
                                |> AnySet.insert capture.capturee
                    in
                    getCapturesByCoord { board = newBoard, turn = game.turn }
                        excludedCaptures
                        capture.destination

                newExcludedCaptures : AnySet String Coord
                newExcludedCaptures =
                    if AnySet.size possibleFurtherCaptures > 0 then
                        game.excludedCaptures
                            |> AnySet.insert capture.capturee

                    else
                        AnySet.empty Coord.toString

                newTurn : Team
                newTurn =
                    if AnySet.size possibleFurtherCaptures > 0 then
                        game.turn

                    else
                        Team.opposite game.turn

                newPossibleMoves : PossibleMoves
                newPossibleMoves =
                    let
                        possibleCaptures : AnySet String Capture
                        possibleCaptures =
                            getAllPossibleCaptures { board = newBoard, turn = newTurn }

                        possibleMoves : AnySet String Move
                        possibleMoves =
                            getAllPossibleMoves { board = newBoard, turn = newTurn }
                    in
                    if AnySet.size possibleFurtherCaptures > 0 then
                        PossibleMoves.Captures possibleFurtherCaptures

                    else if AnySet.size possibleCaptures > 0 then
                        PossibleMoves.Captures possibleCaptures

                    else if AnySet.size possibleMoves > 0 then
                        PossibleMoves.Moves possibleMoves

                    else
                        PossibleMoves.None

                newPieceSelected : Maybe Coord
                newPieceSelected =
                    if AnySet.size possibleFurtherCaptures > 0 then
                        Just capture.destination

                    else
                        Nothing
            in
            { board = newBoard
            , turn = newTurn
            , pieceSelected = newPieceSelected
            , possibleMoves = newPossibleMoves
            , excludedCaptures = newExcludedCaptures
            }
                |> promoteLastRowsToOfficers

        _ ->
            game


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
