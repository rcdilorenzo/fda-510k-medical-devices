module Models.Message exposing (..)

import Models.Route exposing (..)

type Message
    = ChangeRoute RouteSection
    | NoOp
