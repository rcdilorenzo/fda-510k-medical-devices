module Models.Flags exposing (..)

type alias FlagPages =
    { about : String
    }

type alias Flags =
    { countryCode : String
    , yearCount : String
    , pages : FlagPages
    }
