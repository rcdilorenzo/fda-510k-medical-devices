module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Navigation as Nav
import Views.Location as Location


-- APP
main : Program Never Int Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Int

model : number
model = 0


-- UPDATE
type Msg = NoOp

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div []
    [ Nav.view
    , div [ class "container", style [("margin-top", "30px")] ]
        [ h1 [] [ text "510k Medical Devices Data"]
        , Location.view
        ]
    ]

