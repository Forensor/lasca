module Page exposing (..)

import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Preferences
import Route


type Msg
    = OpenPreferences


viewHeader : Html msg
viewHeader =
    let
        navLinksClasses : Attribute msg
        navLinksClasses =
            Attrs.class "flex items-center justify-center pt-[8px]"

        animationClasses : Attribute msg
        animationClasses =
            Attrs.class "hover:opacity-50 transition-opacity duration-200"
    in
    Html.header
        [ Attrs.class "w-full h-[50px] flex items-center justify-center"
        , Attrs.class
            "bg-[linear-gradient(0deg,_rgba(255,255,255,0)_0%,_rgba(0,0,0,0.15)_100%)]"
        ]
        [ Html.nav [ Attrs.class "flex gap-[20px]" ]
            [ Html.a
                [ Route.href Route.Home
                , Attrs.class "font-bold text-[30px] flex items-center justify-center"
                , animationClasses
                ]
                [ Html.text "lasca" ]
            , Html.a
                [ Route.href Route.Home
                , navLinksClasses
                , animationClasses
                ]
                [ Html.text "HOME" ]
            , Html.a
                [ Route.href Route.Rules
                , navLinksClasses
                , animationClasses
                ]
                [ Html.text "RULES" ]
            , Html.a
                [ Route.href Route.Analysis
                , navLinksClasses
                , animationClasses
                ]
                [ Html.text "ANALYSIS" ]
            ]
        , Html.button
            [ Attrs.class "absolute right-[10px]"
            , animationClasses
            , Attrs.attribute "aria-label" "preferences"
            ]
            [ Preferences.icon
            ]
        ]
