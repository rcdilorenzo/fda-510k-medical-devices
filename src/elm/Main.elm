port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

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
      (yearCount "yearCount" files.yearCount)
      ((subcatVsDecision "subcatVsDecision" files.subcategoryVsDecisionCount) |> wrapAsPaging 15)
      ((deviceNouns "deviceNouns" files.deviceNounCount) |> wrapAsPaging 30)
      (reviewDaysAvg "reviewDaysAvg" files.reviewDaysAvgCount)
      (topApplicants "topApplicants" files.applicantCount)


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
      , plot charts.yearCount
      , plot (applyPaging charts.subcatVsDecision)
      , plot (applyPaging charts.deviceNouns)
      , plot charts.reviewDaysAvg
      , plot charts.topApplicants
      ] |> Cmd.batch


update : Message -> State -> (State, Cmd Message)
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)

        ChangeRoute route ->
            ({ model | route = route }, allChartsCmd model.charts)

        UpdateSubcat chartMsg ->
            let
                charts = model.charts
                (chart, cmd) = updatePagingChart charts.subcatVsDecision chartMsg
                newCharts = { charts | subcatVsDecision = chart }
            in
                ({ model | charts = newCharts}, cmd)

        UpdateNouns chartMsg ->
            let
                charts = model.charts
                (chart, cmd) = updatePagingChart charts.deviceNouns chartMsg
                newCharts = { charts | deviceNouns = chart }
            in
                ({ model | charts = newCharts}, cmd)


updatePagingChart : PagingChart -> ChartMessage -> (PagingChart, Cmd a)
updatePagingChart pagingChart msg =
    case msg of
        Increment ->
            let
                page = pagingChart.page
                rowCount = List.length pagingChart.chart.data.labels
                newPage = if (page + 1) <= (lastPage pagingChart) then page + 1 else page
                newChart = { pagingChart | page = newPage }
                cmd = if newPage /= page then (newChart |> applyPaging |> plot) else Cmd.none
            in
                (newChart, cmd)

        Decrement ->
            let
                page = pagingChart.page
                newPage = Basics.max (page - 1) 1
                newChart = { pagingChart | page = newPage }
                cmd = if newPage /= page then (newChart |> applyPaging |> plot) else Cmd.none
            in
                (newChart, cmd)



view : State -> Html Message
view model =
    div []
        [ (Nav.view model)
        , div [ class "container" ]
            [ contentView model ]
        ]


contentView : State -> Html Message
contentView model =
    case model.route of
        ResultsR ->
            Pages.Results.view model
        ProcessR ->
            Pages.Static.view model.pages.process
        AboutR ->
            Pages.Static.view model.pages.about


port plot : Chart -> Cmd msg
