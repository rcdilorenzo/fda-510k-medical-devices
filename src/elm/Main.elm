port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Navigation as Nav
import Views.Location as Location
import Models.Chart exposing (..)


main : Program Never Model Msg
main =
  Html.program
      { init = init
      , view = view
      , update = update
      , subscriptions = (\_ -> Sub.none) }


type alias Model = {}

init : (Model, Cmd msg)
init = ({}, plot (sample "sample"))


type Msg = NoOp

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> (model, Cmd.none)


view : Model -> Html Msg
view model =
  div []
    [ Nav.view
    , div [ class "container", style [("margin-top", "30px")] ]
        [ h1 [] [ text "510k Medical Devices Data"]
        , canvas [ id "sample", width 400, height 400 ] []
        , Location.view
        ]
    ]


port plot : Chart -> Cmd msg
