module Route exposing (Route(..), fromUrl)

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Home
    | Game String
    | Rules
    | Watch


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Game <| (Parser.s "game" </> Parser.string)
        , Parser.map Rules <| Parser.s "rules"
        , Parser.map Watch <| Parser.s "watch"
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url
