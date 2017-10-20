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
