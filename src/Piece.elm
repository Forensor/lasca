module Piece exposing (Msg, Piece, defaultSize, role, team, view)

import Coord exposing (Coord)
import Counter exposing (Counter)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Role exposing (Role)
import Svg.Attributes as SvgAttrs
import Team exposing (Team)


{-| A stack of `Counter`s.

The head of the `NonEmpty` represents the topmost `Counter` of the stack, which designs
the `Team` and the `Role` of it.

-}
type alias Piece =
    NonEmpty Counter


type Msg
    = DragPiece Coord
    | DropPiece Coord


defaultSize : Int
defaultSize =
    70


team : Piece -> Team
team ( topmostCounter, _ ) =
    topmostCounter.team


role : Piece -> Role
role ( topmostCounter, _ ) =
    topmostCounter.role


{-| Render a `Piece` on a specific `Coord`.

Configuration allows you to set custom `pieceSize`, which affects the size of the whole
`Board`.

-}
view : { pieceSize : Int } -> Coord -> Piece -> Html Msg
view { pieceSize } coord piece =
    let
        { top, left } =
            Coord.topAndLeftValues { pieceSize = pieceSize } coord
    in
    Html.node "piece"
        [ Attrs.class "piece block absolute cursor-pointer"

        {- For some reason `Html.Attributes.style` doesn't work with this, neither does
           tailwindcss, so this is a workaround...
        -}
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromInt top ++ "px;"
                , "left: " ++ String.fromInt left ++ "px;"
                , "height: " ++ String.fromInt pieceSize ++ "px;"
                , "width: " ++ String.fromInt pieceSize ++ "px;"
                ]
        , Attrs.class <| Coord.toString coord
        , Events.onMouseDown <| DragPiece coord
        , Events.onMouseUp <| DropPiece coord
        ]
        (piece
            |> NonEmpty.indexedMap
                (\index counter ->
                    let
                        {- We need to invert indices since topmost `Counter` is the head
                           of the `NonEmpty`
                        -}
                        positionOnStack : Int
                        positionOnStack =
                            (NonEmpty.length piece - 1) - index
                    in
                    Counter.view
                        { positionOnStack = positionOnStack
                        , counterSize = pieceSize
                        }
                        counter
                )
            |> NonEmpty.toList
        )
