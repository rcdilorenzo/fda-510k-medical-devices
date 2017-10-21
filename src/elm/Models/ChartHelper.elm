module Models.ChartHelper exposing (..)

import Models.Chart exposing (..)

import CsvDecode exposing (..)
import List.Extra exposing (groupWhile)

type alias RowFrequency =
    { label : String
    , value : Int
    }

type alias RowFrequency2 =
    { label : String
    , altLabel : String
    , value : Int
    }


freqChart : String -> String -> String -> Maybe Int -> List RowFrequency -> Chart
freqChart id chartType name size rawRows =
    let
        labels = List.map (\row -> row.label) rawRows

        color
            = List.head availableColors
            |> Maybe.withDefault "#000"

        dataset = ChartDataset name color (List.map (\r -> r.value) rawRows)
    in
        Chart id chartType size (ChartData labels [dataset])


freq2Chart : String -> String -> Maybe Int -> List RowFrequency2 -> Chart
freq2Chart id chartType size rawRows =
    let
        labels
            = groupWhile (\left right -> left.label == right.label) rawRows
            |> List.map compactRows
            |> List.map (\row -> row.label)

        subcategoryDatasets
            = List.sortBy (\row -> row.altLabel) rawRows
            |> groupWhile (\left right -> left.altLabel == right.altLabel)
            |> List.map (\rows -> ChartDataset (firstLabel (\r -> r.altLabel) rows) "" (labelOrderedValues rows labels))
            |> List.map2 (\color dataset -> { dataset | backgroundColor = color}) availableColors
    in
        Chart id chartType size (ChartData labels subcategoryDatasets)


firstLabel :(RowFrequency2 -> String) -> List RowFrequency2 -> String
firstLabel func rows =
    rows
    |> List.head
    |> Maybe.map func
    |> Maybe.withDefault "<unknown>"


labelOrderedValues : List RowFrequency2 -> List String -> List Int
labelOrderedValues rows labels =
    labels
    |> List.map (\label -> List.filter (\r -> r.label == label) rows |> List.head |> Maybe.withDefault emptyRow2)
    |> List.map (\r -> r.value)


emptyRow2 : RowFrequency2
emptyRow2 = RowFrequency2 "" "" 0


rowFreqDecoder : String -> String -> Decoder RowFrequency
rowFreqDecoder labelKey valueKey =
    succeed RowFrequency
        |= field labelKey
        |= int (field valueKey)


rowFreq2Decoder : String -> String -> String -> Decoder RowFrequency2
rowFreq2Decoder labelKey altLabelKey valueKey =
    succeed RowFrequency2
        |= field labelKey
        |= field altLabelKey
        |= int (field valueKey)

compactRows : List RowFrequency2 -> RowFrequency
compactRows rows =
    let
        label = List.head rows |> Maybe.map (\r -> r.label) |> Maybe.withDefault "<unknown>"
        value = List.map (\r -> r.value) rows |> List.sum
    in
        RowFrequency label value


rowsFreq2From : String -> String -> String -> String -> List RowFrequency2
rowsFreq2From generalKey specificKey countKey raw =
    let
        decoder = rowFreq2Decoder generalKey specificKey countKey
    in
        Result.withDefault [] (CsvDecode.run decoder raw)


rowsFreqFrom : String -> String -> String -> List RowFrequency
rowsFreqFrom labelKey countKey raw =
    let
        decoder = rowFreqDecoder labelKey countKey
    in
        Result.withDefault [] (CsvDecode.run decoder raw)

valueCompare : { a | value : comparable } -> { b | value : comparable } -> Order
valueCompare left right =
    case compare left.value right.value of
        LT -> GT
        GT -> LT
        EQ -> EQ


availableColors : List String
availableColors =
    [ "#1B9DA0" , "#A03D33" , "#1C82AA" , "#082446"
    , "#AA5429" , "#D89048" , "#783030" , "#85775D"
    , "#6B4116" , "#783643" , "#41524D" , "#807061"
    , "#29555F" , "#789A8C" , "#352D2B" , "#B7CAD8"
    ]


colors : Int -> List String
colors n =
    List.take n availableColors
