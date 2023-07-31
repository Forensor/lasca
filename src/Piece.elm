module Piece exposing (Piece, role, team, view)

import Coord exposing (Coord)
import Counter exposing (Counter)
import Html exposing (Html)
import Html.Attributes as Attrs
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


team : Piece -> Team
team ( topmostCounter, _ ) =
    topmostCounter.team


role : Piece -> Role
role ( topmostCounter, _ ) =
    topmostCounter.role


{-| Render a `Piece` on a specific `Coord`.
-}
view : Coord -> Piece -> Html msg
view coord piece =
    let
        { top, left } =
            Coord.topAndLeftValues coord
    in
    Html.node "piece"
        [ Attrs.class "piece block w-[70px] h-[70px] absolute"

        {- For some reason `Html.Attributes.style` doesn't work with this, neither does
           tailwindcss, so this is a workaround...
        -}
        , SvgAttrs.style <|
            String.join " "
                [ "top: " ++ String.fromInt top ++ "px;"
                , "left: " ++ String.fromInt left ++ "px;"
                ]
        , Attrs.class <| Coord.toString coord
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
                    Counter.view { positionOnStack = positionOnStack } counter
                )
            |> NonEmpty.toList
        )
