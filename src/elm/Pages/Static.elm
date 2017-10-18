module Pages.Static exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Models.Flags exposing (..)
import Json.Encode

import Markdown

view : String -> Html msg
view page =
    Markdown.toHtml [] page
