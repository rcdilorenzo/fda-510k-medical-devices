module Pages.Static exposing (view)

import Html exposing (..)

import Markdown

view : String -> Html msg
view page =
    Markdown.toHtml [] page
