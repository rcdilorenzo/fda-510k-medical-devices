module Pages.Results exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Models.Flags exposing (..)
import Models.State exposing (..)
import Models.Message exposing (..)
import Pages.Static

import Components.ChartPager as Pager

view : State -> Html Message
view model =
    div []
        [ Pages.Static.view model.pages.intro
        , Pages.Static.view model.pages.section1
        , Pages.Static.view model.pages.section2
        , Pages.Static.view model.pages.section3
        , Pages.Static.view model.pages.section4a
        , Pager.view (model.charts.subcatVsDecision |> Debug.log "chart") (UpdateSubcat Decrement) (UpdateSubcat Increment)
        , canvas [ id "subcatVsDecision", style [("max-height", "400px")] ] []
        , p [] [ text "hey" ]
        ]
