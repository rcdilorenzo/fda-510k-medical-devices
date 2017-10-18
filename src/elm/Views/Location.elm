module Views.Location exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html any
view =
    usApplications

usApplications : Html any
usApplications =
    div []
        [ h2 [] [ text "U.S. Medical Device Applicants" ]
        , canvas [ id "sample" ] []
        , p [] [ text "This is a test." ]
        , iframe [ height 600, src "https://plot.ly/~rcdilorenzo/6.embed" ] []
        ]
