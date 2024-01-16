module Preferences exposing
    ( Preferences
    , default
    , dropdownId
    , gearButtonId
    , viewDropdown
    , viewGearButton
    )

{-| User preferences for custom configuration.

Most of them come from flags through app initialization.

-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Orientation exposing (Orientation)
import Piece
import Svg
import Svg.Attributes as SvgAttrs


{-| User `Preferences` for the application.
-}
type alias Preferences =
    { pieceSize : Float
    , orientation : Orientation
    }


default : Preferences
default =
    { pieceSize = Piece.defaultSize
    , orientation = Orientation.default
    }



-- All view related stuff is beyond here


icon : Html msg
icon =
    Svg.svg
        [ Attrs.attribute "height" "20"
        , SvgAttrs.viewBox "0 0 24 24"
        , Attrs.attribute "width" "20"
        ]
        [ Svg.path
            [ SvgAttrs.d <|
                "M24 13.616v-3.232c-1.651-.587-2.694-.752-3.219-2.019v-.001c-."
                    ++ "527-1.271.1-2.134.847-3.707l-2.285-2.285c-1.561.742-2.433"
                    ++ " 1.375-3.707.847h-.001c-1.269-.526-1.435-1.576-2.019-3.219h-3."
                    ++ "232c-.582 1.635-.749 2.692-2.019 3.219h-.001c-1.271.528-2.132-."
                    ++ "098-3.707-.847l-2.285 2.285c.745 1.568 1.375 2.434.847 3.707-."
                    ++ "527 1.271-1.584 1.438-3.219 2.02v3.232c1.632.58 2.692.749 3.219 "
                    ++ "2.019.53 1.282-.114 2.166-.847 3.707l2.285 2.286c1.562-.743 "
                    ++ "2.434-1.375 3.707-.847h.001c1.27.526 1.436 1.579 2.019 3.219h3."
                    ++ "232c.582-1.636.75-2.69 2.027-3.222h.001c1.262-.524 2.12.101 3."
                    ++ "698.851l2.285-2.286c-.744-1.563-1.375-2.433-.848-3.706.527-1.271"
                    ++ " 1.588-1.44 3.221-2.021zm-12 2.384c-2.209 0-4-1.791-4-4s1.791-4"
                    ++ " 4-4 4 1.791 4 4-1.791 4-4 4z"
            ]
            []
        ]


viewGearButton : msg -> Html msg
viewGearButton preferencesButtonOnClickMsg =
    Html.button
        [ Attrs.id gearButtonId
        , Attrs.class "absolute right-[10px]"
        , Attrs.class "hover:opacity-50 transition-opacity duration-200"
        , Attrs.attribute "aria-label" "preferences"
        , Events.onClick preferencesButtonOnClickMsg
        ]
        [ icon
        ]


type alias DropdownConfig msg =
    { enlargeBoardSizeButtonMsg : msg
    , reduceBoardSizeButtonMsg : msg
    , swapBoardOrientationMsg : msg
    }


viewDropdown :
    DropdownConfig msg
    -> Html msg
viewDropdown config =
    let
        boardSizeButtonClasses : Attribute msg
        boardSizeButtonClasses =
            Attrs.class <|
                String.join " "
                    [ "bg-gunmetal"
                    , "text-white"
                    , "w-[30px]"
                    , "h-[30px]"
                    , "border"
                    , "border-white/25"
                    , "hover:opacity-50"
                    , "transition-opacity"
                    , "duration-200"
                    , "rounded-[2px]"
                    ]
    in
    Html.ul
        [ Attrs.id dropdownId
        , Attrs.class "bg-white absolute top-[40px] right-[10px] shadow-lg w-[250px]"
        , Attrs.class "rounded-[4px] cursor-pointer p-[5px_10px] select-none"
        ]
        [ Html.li
            [ Attrs.class
                "h-[40px] flex items-center place-content-between"
            ]
            [ Html.p [] [ Html.text "Board Size" ]
            , Html.div []
                [ Html.button
                    [ boardSizeButtonClasses
                    , Attrs.class "mr-[4px]"
                    , Events.onClick config.reduceBoardSizeButtonMsg
                    ]
                    [ Html.text "-" ]
                , Html.button
                    [ boardSizeButtonClasses
                    , Events.onClick config.enlargeBoardSizeButtonMsg
                    ]
                    [ Html.text "+" ]
                ]
            ]
        , Html.li
            [ Attrs.class
                "h-[40px] flex items-center place-content-between"
            ]
            [ Html.p [] [ Html.text "Board Orientation" ]
            , Html.div []
                [ Html.button
                    [ boardSizeButtonClasses
                    , Events.onClick config.swapBoardOrientationMsg
                    ]
                    [ Html.text "↻" ]
                ]
            ]
        ]


dropdownId : String
dropdownId =
    "preferences-dropdown"


gearButtonId : String
gearButtonId =
    "preferences-button"
