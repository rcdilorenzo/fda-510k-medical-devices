module Pages.Results exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Models.Flags exposing (..)
import Models.State exposing (..)
import Pages.Static

view : State -> Html any
view model =
    div []
        [ Pages.Static.view model.pages.intro
        , usApplications
        ]

usApplications : Html any
usApplications =
    div []
        [ h2 [] [ text "What kind of devices are considered safe?" ]
        , canvas [ id "catVsDec" ] []
        ]
        --- , iframe [ height 600, src "https://plot.ly/~rcdilorenzo/6.embed" ] []
