port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Navigation as Nav

import Views.Location as Location

import Models.Flags exposing (..)
import Models.Chart exposing (..)
import Models.Route exposing (..)
import Models.Message exposing (..)
import Models.State exposing (..)

import Pages.Static


main : Program Flags State Message
main =
    Html.programWithFlags
      { init = init
      , view = view
      , update = update
      , subscriptions = (\_ -> Sub.none) }

init : Flags -> (State, Cmd msg)
init flags = ((State ResultsR flags.pages), plot (sample "sample"))


update : Message -> State -> (State, Cmd Message)
update msg model =
    case msg of
        NoOp -> (model, Cmd.none)
        ChangeRoute route -> ({ model | route = route }, plot (sample "sample"))


view : State -> Html Message
view model =
    div []
        [ (Nav.view model)
        , div [ class "container", style [("margin-top", "30px")] ]
            [ contentView model ]
        ]

contentView : State -> Html Message
contentView model =
    case model.route of
        ResultsR ->
            Location.view
        ProcessR ->
            Pages.Static.view "To be expanded..."
        AboutR ->
            Pages.Static.view model.pages.about


port plot : Chart -> Cmd msg
