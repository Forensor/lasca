module Route exposing (Route(..), fromUrl, href)

import Html exposing (Attribute)
import Html.Attributes as Attrs
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Home
    | Game String
    | Rules
    | Analysis


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Game <| (Parser.s "game" </> Parser.string)
        , Parser.map Rules <| Parser.s "rules"
        , Parser.map Analysis <| Parser.s "analysis"
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


toString : Route -> String
toString route =
    case route of
        Home ->
            "/"

        Game id ->
            "/" ++ id

        Rules ->
            "/rules"

        Analysis ->
            "/analysis"


href : Route -> Attribute msg
href route =
    Attrs.href <| toString route
