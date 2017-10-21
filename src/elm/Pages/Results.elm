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
        , Pages.Static.view model.pages.section1
        , Pages.Static.view model.pages.section2
        ]

--- , iframe [ height 600, src "https://plot.ly/~rcdilorenzo/6.embed" ] []
