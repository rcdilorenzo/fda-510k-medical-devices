module Models.Message exposing (..)

import Models.Route exposing (..)

type ChartMessage
    = Increment
    | Decrement

type Message
    = ChangeRoute RouteSection
    | UpdateSubcat ChartMessage
    | UpdateNouns ChartMessage
    | NoOp
