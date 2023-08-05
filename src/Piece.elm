module Piece exposing
    ( Piece
    , className
    , convertToOfficerByTeam
    , defaultSize
    , role
    , selectedClassName
    , team
    , view
    )

import Coord exposing (Coord)
import Counter exposing (Counter)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode
import List.NonEmpty as NonEmpty exposing (NonEmpty)
import Orientation exposing (Orientation)
import Role exposing (Role)
import Svg.Attributes as SvgAttrs
import Team exposing (Team)


{-| A stack of `Counter`s.

The head of the `NonEmpty` represents the topmost `Counter` of the stack, which designs
the `Team` and the `Role` of it.

-}
type alias Piece =
    NonEmpty Counter


type alias Config msg =
    { clickPieceToMsg : Coord -> msg
    , pieceSize : Float
    , orientation : Orientation
    , selected : Bool
    }


defaultSize : Float
defaultSize =
    105


team : Piece -> Team
team ( topmostCounter, _ ) =
    topmostCounter.team


role : Piece -> Role
role ( topmostCounter, _ ) =
    topmostCounter.role


selectedClassName : String
selectedClassName =
    "piece-selected"


className : String
className =
    "piece"


convertToOfficerByTeam : Team -> Piece -> Piece
convertToOfficerByTeam desiredTeam ( topmostCounter, rest ) =
    if topmostCounter.team == desiredTeam then
        ( { team = topmostCounter.team, role = Role.Officer }, rest )

    else
        ( topmostCounter, rest )


{-| Render a `Piece` on a specific `Coord`.

Configuration allows you to set custom `pieceSize`, which affects the size of the whole
`Board`.

-}
view : Config msg -> Coord -> Piece -> Html msg
view config coord piece =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord

        selectedClassNameIfSelected : List (Attribute msg)
        selectedClassNameIfSelected =
            if config.selected then
                [ Attrs.class selectedClassName ]

            else
                []
    in
    Html.node "piece"
        (selectedClassNameIfSelected
            ++ [ Attrs.class className
               , Attrs.class <| Team.className <| team piece
               , Attrs.class "block absolute"

               {- For some reason `Html.Attributes.style` doesn't work with this, neither
                  does tailwindcss, so this is a workaround...
               -}
               , SvgAttrs.style <|
                    String.join " "
                        [ "top: " ++ String.fromFloat top ++ "px;"
                        , "left: " ++ String.fromFloat left ++ "px;"
                        , "height: " ++ String.fromFloat config.pieceSize ++ "px;"
                        , "width: " ++ String.fromFloat config.pieceSize ++ "px;"
                        ]
               , Attrs.class <| Coord.toString coord
               , Events.onClick <| config.clickPieceToMsg coord
               ]
        )
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
                        , counterSize = config.pieceSize
                        }
                        counter
                )
            |> NonEmpty.toList
        )
