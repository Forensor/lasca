module Page exposing
    ( clickOutsideElementClassesEvent
    , clickOutsideElementIdsEvent
    , decodeClickOutsideElementIds
    , viewHeader
    , viewIf
    )

import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Preferences
import Route


viewHeader : msg -> Html msg
viewHeader preferencesButtonOnClickMsg =
    let
        navLinksClasses : Attribute msg
        navLinksClasses =
            Attrs.class "flex items-center justify-center pt-[8px]"

        animationClasses : Attribute msg
        animationClasses =
            Attrs.class "hover:opacity-50 transition-opacity duration-200"
    in
    Html.header
        [ Attrs.class "w-full h-[50px] flex items-center justify-center select-none"
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
        , Preferences.viewGearButton preferencesButtonOnClickMsg
        ]


viewIf : Bool -> Html msg -> Html msg
viewIf condition view =
    if condition then
        view

    else
        Html.text ""


isOutsideElementIds : List String -> Decoder Bool
isOutsideElementIds elementIds =
    Decode.oneOf
        [ Decode.field "id" Decode.string
            |> Decode.andThen
                (\targetId ->
                    if List.member targetId elementIds then
                        Decode.succeed False

                    else
                        Decode.fail <|
                            "Not clicking outside element with any of these ids: "
                                ++ String.join ", " elementIds
                )
        , Decode.lazy
            (\_ ->
                isOutsideElementIds elementIds
                    |> Decode.field "parentNode"
            )
        , Decode.succeed True
        ]


decodeClickOutsideElementIds : msg -> List String -> Decoder msg
decodeClickOutsideElementIds msg elementIds =
    Decode.field "target" (isOutsideElementIds elementIds)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed msg

                else
                    Decode.fail <|
                        "Not clicking outside element with any of these ids: "
                            ++ String.join ", " elementIds
            )


clickOutsideElementIdsEvent : msg -> List String -> Attribute msg
clickOutsideElementIdsEvent msg elementIds =
    Events.on "click"
        (decodeClickOutsideElementIds
            msg
            elementIds
        )


isOutsideElementClasses : List String -> Decoder Bool
isOutsideElementClasses elementClasses =
    Decode.oneOf
        [ Decode.field "className" Decode.string
            |> Decode.andThen
                (\targetClassName ->
                    if
                        List.any
                            (\targetClass ->
                                List.member targetClass elementClasses
                            )
                            (String.split " " targetClassName)
                    then
                        Decode.succeed False

                    else
                        Decode.fail <|
                            "Not clicking outside element with any of these classes: "
                                ++ String.join ", " elementClasses
                )
        , Decode.lazy
            (\_ ->
                isOutsideElementClasses elementClasses
                    |> Decode.field "parentNode"
            )
        , Decode.succeed True
        ]


decodeClickOutsideElementClasses : msg -> List String -> Decoder msg
decodeClickOutsideElementClasses msg elementClasses =
    Decode.field "target" (isOutsideElementClasses elementClasses)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed msg

                else
                    Decode.fail <|
                        "Not clicking outside element with any of these classes: "
                            ++ String.join ", " elementClasses
            )


clickOutsideElementClassesEvent : msg -> List String -> Attribute msg
clickOutsideElementClassesEvent msg elementClasses =
    Events.on "click"
        (decodeClickOutsideElementClasses
            msg
            elementClasses
        )
