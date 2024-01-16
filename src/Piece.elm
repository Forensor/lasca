module Piece exposing
    ( DraggingState(..)
    , Piece
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
    , toString
    , view
    )

import Coord exposing (Coord)
import Counter exposing (Counter)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode
import Json.Decode.Extra as Decode
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


toString : Piece -> String
toString piece =
    NonEmpty.map Counter.toString piece
        |> NonEmpty.toList
        |> String.join ""



-- All view related stuff is beyond here


type DraggingState
    = Static
    | Dragged
        { mouseX : Float
        , mouseY : Float
        }


{-| Configuration for `Piece` related views.
-}
type alias Config msg =
    { pieceSize : Float
    , orientation : Orientation
    , selectedPiece : Maybe ( Coord, DraggingState )
    , onDragPieceEventToMsg : Coord -> { mouseX : Float, mouseY : Float } -> msg
    , hoveredCoordToMsg : Maybe Coord -> msg
    , shouldHaveEvents : Bool
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
view : Config msg -> Coord -> Piece -> Html msg
view config coord piece =
    let
        { top, left } =
            case config.selectedPiece of
                Just ( coord_, draggingState ) ->
                    case ( draggingState, coord_ == coord ) of
                        ( Dragged { mouseX, mouseY }, True ) ->
                            { top = mouseY - config.pieceSize / 2
                            , left = mouseX - config.pieceSize / 2
                            }

                        _ ->
                            Coord.topAndLeftValues
                                { pieceSize = config.pieceSize
                                , orientation = config.orientation
                                }
                                coord

                Nothing ->
                    Coord.topAndLeftValues
                        { pieceSize = config.pieceSize
                        , orientation = config.orientation
                        }
                        coord

        elementPositionClass : String
        elementPositionClass =
            case config.selectedPiece of
                Just ( coord_, draggingState ) ->
                    case ( draggingState, coord_ == coord ) of
                        ( Dragged _, True ) ->
                            "fixed pointer-events-none"

                        _ ->
                            "absolute"

                Nothing ->
                    "absolute"

        zIndexClass : List (Attribute msg)
        zIndexClass =
            case config.selectedPiece of
                Just ( coord_, draggingState ) ->
                    case ( draggingState, coord_ == coord ) of
                        ( Dragged _, True ) ->
                            [ Attrs.class "z-[1000]" ]

                        _ ->
                            []

                Nothing ->
                    []

        mouseEvents : List (Attribute msg)
        mouseEvents =
            if config.shouldHaveEvents then
                [ Events.onMouseOver <| config.hoveredCoordToMsg (Just coord)
                , Events.onMouseLeave <| config.hoveredCoordToMsg Nothing
                , Events.preventDefaultOn "mousedown"
                    (Decode.field "button" Decode.int
                        |> Decode.andThen
                            (\mouseButtonPressed ->
                                case mouseButtonPressed of
                                    0 ->
                                        Decode.succeed
                                            (\mouseX mouseY ->
                                                ( config.onDragPieceEventToMsg coord
                                                    { mouseX = mouseX
                                                    , mouseY = mouseY
                                                    }
                                                , True
                                                )
                                            )
                                            |> Decode.andMap
                                                (Decode.field
                                                    "clientX"
                                                    Decode.float
                                                )
                                            |> Decode.andMap
                                                (Decode.field
                                                    "clientY"
                                                    Decode.float
                                                )

                                    _ ->
                                        Decode.fail "No mousedown with left click"
                            )
                    )
                ]

            else
                []
    in
    Html.node "piece"
        ([ Attrs.class className
         , Attrs.class <| Team.className <| team piece
         , Attrs.class "block cursor-pointer"
         , Attrs.class elementPositionClass
         , Attrs.classList
            [ ( selectedClassName
              , config.selectedPiece
                    |> Maybe.map (\( coord_, _ ) -> coord_ == coord)
                    |> Maybe.withDefault False
              )
            ]

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
            ++ zIndexClass
            ++ mouseEvents
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
