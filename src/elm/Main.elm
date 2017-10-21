port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import Components.Navigation as Nav

import Models.Flags exposing (..)
import Models.Chart exposing (..)
import Models.Route exposing (..)
import Models.Message exposing (..)
import Models.State exposing (..)
import Models.ChartImporter exposing (..)

import Pages.Results
import Pages.Static


main : Program Flags State Message
main =
    Html.programWithFlags
      { init = init
      , view = view
      , update = update
      , subscriptions = (\_ -> Sub.none) }


init : Flags -> (State, Cmd msg)
init flags =
    let
        chartStates = initChartStates flags.files
    in
      ( (State ResultsR flags.pages chartStates)
      , allChartsCmd chartStates)


initChartStates : FlagFiles -> ChartStates
initChartStates files =
    ChartStates
      (categoryVsDecision "catVsDec" files.categoryVsDecisionCount)
      (yearVsDecisionOrtho "yearVsDecision--ortho" files.yearVsDecisionOrthoCount)


allChartsCmd : ChartStates -> Cmd msg
allChartsCmd charts =
    let
        modifiedCatVsDecision
            = charts.categoryVsDecision
            |> chartExcept "Substantially Equivalent" "catVsDec--no-primary"
    in
      [ plot charts.categoryVsDecision
      , plot modifiedCatVsDecision
      , plot charts.yearVsDecisionOrtho
      ] |> Cmd.batch


update : Message -> State -> (State, Cmd Message)
update msg model =
    case msg of
        NoOp -> (model, Cmd.none)
        ChangeRoute route -> ({ model | route = route }, allChartsCmd model.charts)


view : State -> Html Message
view model =
    div []
        [ (Nav.view model)
        , div [ class "container", style [("margin-top", "30px")] ]
            [ contentView model ]
        ]


contentView : State -> Html Message
contentView model =
    case model.route of
        ResultsR ->
            Pages.Results.view model
        ProcessR ->
            Pages.Static.view "To be expanded..."
        AboutR ->
            Pages.Static.view model.pages.about


port plot : Chart -> Cmd msg
