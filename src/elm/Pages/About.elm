module Pages.About exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Models.Flags exposing (..)
import Json.Encode

import Markdown

view : FlagPages -> Html msg
view pages =
    Markdown.toHtml [] pages.about
