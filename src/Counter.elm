module Counter exposing (Counter, directions, view)

import Dict.Any as AnyDict exposing (AnyDict)
import Direction exposing (Direction)
import Html exposing (Html)
import Role exposing (Role)
import Set.Any as AnySet exposing (AnySet)
import Svg
import Svg.Attributes as SvgAttrs
import Team exposing (Team)


{-| A single "man" of a `Piece`.
-}
type alias Counter =
    { team : Team
    , role : Role
    }


{-| States where a `Team`/`Role` combo can go.

Example:

```
-- Check if `{ team = Team.White, role = Role.Soldier }` can go `Direction.DownRight`:
AnyDict.get Direction.DownRight directions
    |> Maybe.map (AnySet.member { team = Team.White, role = Role.Soldier })
    -- `False`, white soldiers are not allowed to go `Direction.DownRight`
```

-}
directions : AnyDict String Direction (AnySet String Counter)
directions =
    AnyDict.fromList Direction.toString
        [ ( Direction.UpLeft
          , AnySet.fromList toString
                [ { team = Team.White, role = Role.Soldier }
                , { team = Team.White, role = Role.Officer }
                , { team = Team.Black, role = Role.Officer }
                ]
          )
        , ( Direction.UpRight
          , AnySet.fromList toString
                [ { team = Team.White, role = Role.Soldier }
                , { team = Team.White, role = Role.Officer }
                , { team = Team.Black, role = Role.Officer }
                ]
          )
        , ( Direction.DownLeft
          , AnySet.fromList toString
                [ { team = Team.Black, role = Role.Soldier }
                , { team = Team.White, role = Role.Officer }
                , { team = Team.Black, role = Role.Officer }
                ]
          )
        , ( Direction.DownRight
          , AnySet.fromList toString
                [ { team = Team.Black, role = Role.Soldier }
                , { team = Team.White, role = Role.Officer }
                , { team = Team.Black, role = Role.Officer }
                ]
          )
        ]


toString : Counter -> String
toString { team, role } =
    case ( team, role ) of
        ( Team.White, Role.Soldier ) ->
            "w"

        ( Team.Black, Role.Soldier ) ->
            "b"

        ( Team.White, Role.Officer ) ->
            "W"

        ( Team.Black, Role.Officer ) ->
            "B"



-- All view related stuff is beyond here


type alias Config =
    { positionOnStack : Int
    , counterSize : Float
    }


{-| Get _svg_'s _stroke_ and _fill_ values for `Piece` view styles.
-}
hexColors : Counter -> { stroke : String, fill : String }
hexColors { team, role } =
    case ( team, role ) of
        ( Team.White, Role.Soldier ) ->
            { stroke = "#B8B8B8", fill = "#E5E5E5" }

        ( Team.Black, Role.Soldier ) ->
            { stroke = "#0A0A0A", fill = "#363636" }

        ( Team.White, Role.Officer ) ->
            { stroke = "#025033", fill = "#04AA6D" }

        ( Team.Black, Role.Officer ) ->
            { stroke = "#822121", fill = "#CD3C3C" }


{-| Render a single `Counter`.

_Stroke_ and _fill_ colors for the _svg_ are based on the `Team`/`Role` combo. _Bottom_
CSS property is based on `positionOnStack`, the higher the value, the higher the
`Counter` will be.

Default height/width is _70px_, thus it's always best to use `counterSize`s that are
divisible by `70`.

-}
view : Config -> Counter -> Html msg
view config counter =
    let
        -- Hex colors based on `Team`/`Role` combo
        { stroke, fill } =
            hexColors counter

        {- Height of the edge of a `Counter`, to beautifully stack one on top of each
           other
        -}
        counterEdgeHeight : Float
        counterEdgeHeight =
            config.counterSize / 7

        -- How much px we apply to bottom CSS property
        marginByPosition : Float
        marginByPosition =
            toFloat config.positionOnStack * counterEdgeHeight
    in
    Svg.svg
        [ SvgAttrs.width <| String.fromFloat config.counterSize
        , SvgAttrs.height <| String.fromFloat config.counterSize
        , SvgAttrs.viewBox "0 0 70 70"
        , SvgAttrs.style <|
            String.join " "
                [ "bottom: " ++ String.fromFloat marginByPosition ++ "px;"
                , "z-index: " ++ String.fromInt config.positionOnStack ++ ";"
                ]
        , SvgAttrs.class "counter absolute"
        ]
        [ Svg.g []
            [ Svg.rect
                [ SvgAttrs.stroke stroke
                , SvgAttrs.height "9"
                , SvgAttrs.width "60"
                , SvgAttrs.y "40.5"
                , SvgAttrs.x "5"
                , SvgAttrs.fill fill
                ]
                []
            , Svg.ellipse
                [ SvgAttrs.ry "10"
                , SvgAttrs.rx "30"
                , SvgAttrs.cy "50"
                , SvgAttrs.cx "35"
                , SvgAttrs.stroke stroke
                , SvgAttrs.fill fill
                ]
                []
            , Svg.rect
                [ SvgAttrs.height "10"
                , SvgAttrs.width "59"
                , SvgAttrs.y "40"
                , SvgAttrs.x "5.5"
                , SvgAttrs.fill fill
                ]
                []
            , Svg.ellipse
                [ SvgAttrs.ry "10"
                , SvgAttrs.rx "30"
                , SvgAttrs.cy "40"
                , SvgAttrs.cx "35"
                , SvgAttrs.stroke stroke
                , SvgAttrs.fill fill
                ]
                []
            ]
        ]
