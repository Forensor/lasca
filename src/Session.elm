module Session exposing (Session, default)

{-| A `Session` is data common to every section of the application.
-}

import Browser.Navigation as Nav
import Preferences exposing (Preferences)


{-| Data common to all pages.
-}
type alias Session =
    { navKey : Nav.Key
    , preferences : Preferences
    }


default : Nav.Key -> Session
default navKey =
    { navKey = navKey
    , preferences = Preferences.default
    }
