module Models.ChartImporter exposing (..)

import Models.Chart exposing (..)
import Models.ChartHelper exposing (..)


yearCount : String -> String -> Chart
yearCount id raw =
    raw
    |> rowsFreqFrom "year" "count"
    |> freqChart id "bar" "Submissions By Year" (Just 100)


yearVsDecisionOrtho : String -> String -> Chart
yearVsDecisionOrtho id raw =
    raw
    |> rowsFreq2From "decision_year" "decision_description" "decision_count"
    |> freq2Chart id "bar" (Just 300)


categoryVsDecision : String -> String -> Chart
categoryVsDecision id raw =
    raw
    |> rowsFreq2From "category_name" "decision_description" "category_count"
    |> freq2Chart id "horizontalBar" (Just 400)

