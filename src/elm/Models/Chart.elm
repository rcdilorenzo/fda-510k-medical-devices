module Models.Chart exposing (..)

type alias Chart =
    { id : String
    , chartType : String
    , height : Maybe Int
    , data : ChartData
    }

type alias Point = { x : Int, y : Int }

type alias ChartData =
    { labels : List String
    , datasets : List ChartDataset
    }


type alias ChartDataset =
    { label : String
    , backgroundColor : String
    , data : List Int
    }


chartExcept : String -> String -> Chart -> Chart
chartExcept name newId chart =
    let
        datasets = List.filter (\dataset -> dataset.label /= name) chart.data.datasets
        original = chart.data
        chartData = { original | datasets = datasets }
    in
        { chart | data = chartData, id = newId }
