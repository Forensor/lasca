module Session exposing (..)

import Browser.Navigation as Nav
import Preferences exposing (Preferences)


{-| Data common to all pages.
-}
type alias Session =
    { navKey : Nav.Key
    , preferences : Preferences
    }


defaultSession : Nav.Key -> Session
defaultSession navKey =
    { navKey = navKey
    , preferences = Preferences.defaultPreferences
    }
