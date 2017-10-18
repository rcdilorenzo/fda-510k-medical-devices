module Models.State exposing (..)

import Models.Flags exposing (..)
import Models.Chart exposing (..)
import Models.Route exposing (..)

type alias State =
    { route : RouteSection
    , pages : FlagPages
    }

