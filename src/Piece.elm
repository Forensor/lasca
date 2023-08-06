module Piece exposing
    ( Piece
    , addCounter
    , className
    , convertToOfficerByTeam
    , defaultSize
    , getTopmostCounter
    , removeTopmostCounter
    , role
    , selectedClassName
    , setRole
    , setTeam
    , team
    , view
    )

import Coord exposing (Coord)
import Counter exposing (Counter)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
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


{-| Get the `Team` of a `Piece`.

It's the one of the topmost `Counter` on the stack.

-}
team : Piece -> Team
team ( topmostCounter, _ ) =
    topmostCounter.team


{-| Get the `Role` of a `Piece`.

It's the one of the topmost `Counter` on the stack.

-}
role : Piece -> Role
role ( topmostCounter, _ ) =
    topmostCounter.role


{-| Get the `Counter` at the top of the stack.
-}
getTopmostCounter : Piece -> Counter
getTopmostCounter ( topmostCounter, _ ) =
    topmostCounter


{-| Set the `Team` of the topmost `Counter`.
-}
setTeam : Piece -> Team -> Piece
setTeam ( topmostCounter, rest ) desiredTeam =
    ( { topmostCounter | team = desiredTeam }, rest )


{-| Set the `Role` of the topmost `Counter`.
-}
setRole : Piece -> Role -> Piece
setRole ( topmostCounter, rest ) desiredRole =
    ( { topmostCounter | role = desiredRole }, rest )


{-| Set the `Piece` `Role` to `Officer` if it belongs to the desired `Team`.
-}
convertToOfficerByTeam : Team -> Piece -> Piece
convertToOfficerByTeam desiredTeam ( topmostCounter, rest ) =
    if topmostCounter.team == desiredTeam then
        ( { team = topmostCounter.team
          , role = Role.Officer
          }
        , rest
        )

    else
        ( topmostCounter, rest )


{-| Drop the topmost `Counter` from the stack.

There's the chance that no more `Counter`s were left, so this would mean that the square
this `Piece` was on is now empty (not present in the `Board` `AnyDict`).

-}
removeTopmostCounter : Piece -> Maybe Piece
removeTopmostCounter ( _, rest ) =
    NonEmpty.fromList rest


{-| Add a `Counter` to the stack.

Every `Counter` is added from below.

-}
addCounter : Piece -> Counter -> Piece
addCounter piece counter =
    NonEmpty.append piece (NonEmpty.singleton counter)



-- All view related stuff is beyond here


{-| Configuration for `Piece` related views.
-}
type alias Config =
    { pieceSize : Float
    , orientation : Orientation
    }


{-| CSS _className_ used to handle Events when the `Piece` is selected.
-}
selectedClassName : String
selectedClassName =
    "piece-selected"


{-| CSS _className_ used to handle Events.
-}
className : String
className =
    "piece"


{-| Default `Piece` container size in pixels.
-}
defaultSize : Float
defaultSize =
    105


{-| Render a `Piece` on a specific `Coord`.

Configuration allows you to set custom `pieceSize`, which affects the size of the whole
`Board`.

-}
view : Config -> Coord -> Piece -> Html msg
view config coord piece =
    let
        { top, left } =
            Coord.topAndLeftValues
                { pieceSize = config.pieceSize
                , orientation = config.orientation
                }
                coord
    in
    Html.node "piece"
        [ Attrs.class className
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
                        , counterSize = config.pieceSize
                        }
                        counter
                )
            |> NonEmpty.toList
        )
