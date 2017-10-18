module Components.Navigation exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Models.Route exposing (..)
import Models.Message exposing (..)
import Models.State exposing (..)

gravatar : String
gravatar = "https://en.gravatar.com/userimage/37840473/07b6e45ebce61c9aea1ce0bc8ec49547.png"

github : String
github = "https://github.com/rcdilorenzo/fda-510k-medical-devices"

view : State -> Html Message
view model =
    header []
        [ div [ class "topnav" ]
            [ div [ class "topnav__inner"]
                [ a [ class "topnav__main", href "#", onClick (ChangeRoute ResultsR)]
                      [ text "openFDA Exploration" ]
                , span [ class "topnav__section topnav__section--right topnav__section--image" ]
                    [ a [ href github ]
                        [ img [ src gravatar ] [] ]
                    , a [ class "topnav__link", href github ]
                        [ text "Christian Di Lorenzo" ]
                    ]
                ]
            ]
        , div [ class "navbar" ]
            [ div [ class "navbar__inner" ]
                [ ul [ class "navbar__links"]
                    [ li [ class "navbar__item" ] [ a (linkAttrs ResultsR model) [ text "Results" ]]
                    , li [ class "navbar__item" ] [ a (linkAttrs ProcessR model) [ text "Process" ]]
                    , li [ class "navbar__item" ] [ a (linkAttrs AboutR model) [ text "About" ]]
                    ]
                ]
            ]
        ]


linkAttrs : RouteSection -> State -> List (Html.Attribute Message)
linkAttrs route model =
    case model.route == route of
        True ->
            [ class "navbar__link navbar__link--active", onClick (ChangeRoute route) ]
        False ->
            [ class "navbar__link", onClick (ChangeRoute route) ]
