module Components.ChartPager exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Json.Encode exposing (string)

import Models.Message exposing (..)
import Models.Chart exposing (..)
import Models.State exposing (..)

import Basics exposing (toString)

view : PagingChart -> Message -> Message -> Html Message
view pagingChart decrement increment =
    div [ class "chart-pager" ]
        [ a [ class "chart-pager__link chart-pager__link--left", onClick decrement, property "innerHTML" (string "&#8249") ] []
        , label [ class "chart-pager__label" ]
            [ text ("Page " ++ (toString pagingChart.page) ++ " of " ++ (lastPage pagingChart |> toString)) ]
        , a [ class "chart-pager__link chart-pager__link--right", onClick increment, property "innerHTML" (string "&#8250") ] []
        ]
