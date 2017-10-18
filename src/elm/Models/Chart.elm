module Models.Chart exposing (..)

type alias Chart =
    { id : String
    , chartType : String
    , data : ChartData
    }

type alias ChartData = LineChartData

type alias Point = { x : Int, y : Int }

type alias LineChartData =
    { labels : List String
    , datasets : List LineChartDataset
    }


type alias LineChartDataset =
    { label : String
    , backgroundColor : String
    , borderColor : String
    , data : List Int
    }

sample : String -> Chart
sample id =
    Chart
        id
        "line"
        (LineChartData
            ["January", "February", "March", "April", "May", "June", "July"]
            [(LineChartDataset
                  "First set"
                  "rgb(255, 99, 132)"
                  "rgb(255, 99, 132)"
                  [0, 10, 5, 2, 20, 30, 25]
             )])
