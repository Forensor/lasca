module Page exposing
    ( decodeTargetOutsideElementIds
    , mouseDownOutsideElementClassesEvent
    , mouseDownOutsideElementIdsEvent
    , mouseUpInsideElementClassesEvent
    , mouseUpOutsideElementClassesEvent
    , viewHeader
    , viewIf
    )

import Browser.Events as BrEvts
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


decodeTargetOutsideElementIds : msg -> List String -> Decoder msg
decodeTargetOutsideElementIds msg elementIds =
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


mouseDownOutsideElementIdsEvent : msg -> List String -> Sub msg
mouseDownOutsideElementIdsEvent msg elementIds =
    BrEvts.onMouseDown
        (decodeTargetOutsideElementIds
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


isInsideElementClasses : List String -> Decoder Bool
isInsideElementClasses elementClasses =
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
                        Decode.succeed True

                    else
                        Decode.fail <|
                            "Not clicking inside element with any of these classes: "
                                ++ String.join ", " elementClasses
                )
        , Decode.lazy
            (\_ ->
                isInsideElementClasses elementClasses
                    |> Decode.field "parentNode"
            )
        , Decode.succeed True
        ]


decodeTargetOutsideElementClasses : msg -> List String -> Decoder msg
decodeTargetOutsideElementClasses msg elementClasses =
    Decode.field "target" (isOutsideElementClasses elementClasses)
        |> Decode.andThen
            (\isOutside ->
                if isOutside then
                    Decode.succeed msg

                else
                    Decode.fail <|
                        "Not clicking inside element with any of these classes: "
                            ++ String.join ", " elementClasses
            )


decodeTargetInsideElementClasses : msg -> List String -> Decoder msg
decodeTargetInsideElementClasses msg elementClasses =
    Decode.field "target" (isInsideElementClasses elementClasses)
        |> Decode.andThen
            (\isInside ->
                if isInside then
                    Decode.succeed msg

                else
                    Decode.fail <|
                        "Not clicking inside element with any of these classes: "
                            ++ String.join ", " elementClasses
            )


mouseDownOutsideElementClassesEvent : msg -> List String -> Sub msg
mouseDownOutsideElementClassesEvent msg elementClasses =
    BrEvts.onMouseDown
        (decodeTargetOutsideElementClasses
            msg
            elementClasses
        )


mouseUpOutsideElementClassesEvent : msg -> List String -> Sub msg
mouseUpOutsideElementClassesEvent msg elementClasses =
    BrEvts.onMouseUp
        (decodeTargetOutsideElementClasses
            msg
            elementClasses
        )


mouseUpInsideElementClassesEvent : msg -> List String -> Sub msg
mouseUpInsideElementClassesEvent msg elementClasses =
    BrEvts.onMouseUp
        (decodeTargetInsideElementClasses
            msg
            elementClasses
        )
