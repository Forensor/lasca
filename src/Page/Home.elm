module Page.Home exposing (..)

import Browser exposing (Document)
import Html exposing (Attribute, Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Page
import Preferences exposing (Preferences)
import Session exposing (Session)


type alias Model =
    { session : Session
    , preferencesPanelIsOpen : Bool
    }


type Msg
    = NoOp String
    | TogglePreferencesPanel
    | SetPreferencesPanelIsOpened Bool


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session
      , preferencesPanelIsOpen = False
      }
    , Cmd.none
    )


view : Model -> Document Msg
view model =
    { title = "lasca"
    , body =
        body model
    }


body : Model -> List (Html Msg)
body model =
    [ Html.div
        [ Attrs.class "h-screen" ]
        [ Page.viewHeader TogglePreferencesPanel
        , Page.viewIf
            model.preferencesPanelIsOpen
            (Preferences.viewDropdown
                { enlargeBoardSizeButtonMsg =
                    NoOp "Ignoring enlarge board size change in Home page"
                , reduceBoardSizeButtonMsg =
                    NoOp "Ignoring reduce board size change in Home page"
                , swapBoardOrientationMsg =
                    NoOp "Ignoring swap board orientation change in Home page"
                }
            )
        , viewContent model
        ]
    ]


viewContent : Model -> Html Msg
viewContent model =
    let
        buttonClasses : Attribute Msg
        buttonClasses =
            Attrs.class <|
                String.join " "
                    [ "rounded-[4px]"
                    , "bg-gunmetal"
                    , "text-white"
                    , "p-[16px]"
                    , "hover:opacity-50"
                    , "transition-opacity"
                    , "duration-200"
                    ]
    in
    Html.div
        [ Attrs.class "flex justify-center pt-[100px]"
        ]
        [ Html.main_ [ Attrs.class "flex flex-col gap-[10px]" ]
            [ Html.button
                [ buttonClasses
                , Attrs.attribute "aria-label" "matchmaking"
                ]
                [ Html.text "ENTER MATCHMAKING" ]
            , Html.button
                [ buttonClasses
                , Attrs.attribute "aria-label" "play"
                ]
                [ Html.text "PLAY AGAINST A FRIEND" ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp _ ->
            ( model, Cmd.none )

        TogglePreferencesPanel ->
            let
                newPreferencesPanelIsOpen : Bool
                newPreferencesPanelIsOpen =
                    not model.preferencesPanelIsOpen
            in
            ( { model
                | preferencesPanelIsOpen = newPreferencesPanelIsOpen
              }
            , Cmd.none
            )

        SetPreferencesPanelIsOpened preferencesPanelIsOpened ->
            ( { model
                | preferencesPanelIsOpen = preferencesPanelIsOpened
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ if model.preferencesPanelIsOpen then
            Page.mouseDownOutsideElementIdsEvent
                (SetPreferencesPanelIsOpened False)
                [ Preferences.dropdownId, Preferences.gearButtonId ]

          else
            Sub.none
        ]
