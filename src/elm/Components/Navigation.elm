module Components.Navigation exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

gravatar : String
gravatar = "https://en.gravatar.com/userimage/37840473/07b6e45ebce61c9aea1ce0bc8ec49547.png"

view : Html any
view =
    header [ class "grid topnav" ]
        [ div [ class "topnav__inner"]
            [ a [ class "topnav__main", href "#"] [ text "openFDA Exploration" ]
            , span [ class "topnav__section topnav__section--right topnav__section--image" ]
                [ a [ href "#" ]
                    [ img [ src gravatar ] [] ]
                , a [ class "topnav__link", href "#" ]
                    [ text "Christian Di Lorenzo" ]
                ]
            ]
        ]
