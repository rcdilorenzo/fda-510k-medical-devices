module Models.Chart exposing (..)

type alias PagingChart =
    { size : Int
    , page : Int
    , chart : Chart
    }

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


wrapAsPaging : Int -> Chart -> PagingChart
wrapAsPaging size chart =
    PagingChart size 1 chart


applyPaging : PagingChart -> Chart
applyPaging {size, page, chart} =
    let
        limit = (\data -> data |> List.drop (size * (page - 1)) |> List.take size)
        datasets = List.map (\dataset -> { dataset | data = (limit dataset.data) }) chart.data.datasets
        originalData = chart.data
        chartData = { originalData | datasets = datasets, labels = (limit chart.data.labels) }
    in
        { chart | data = chartData }

lastPage : PagingChart -> Int
lastPage pagingChart =
    let
        rowCount = List.length pagingChart.chart.data.labels
    in
        Basics.ceiling ((toFloat rowCount) / (toFloat pagingChart.size))



