module Models.Flags exposing (..)

type alias FlagFiles =
    { applicantCount : String
    , categoryVsDecisionCount : String
    , deviceNounCount : String
    , expeditedReviewCount : String
    , reviewDaysAvgCount : String
    , subcategoryVsDecisionCount : String
    , yearVsDecisionOrthoCount : String
    , yearCount : String
    }

type alias FlagPages =
    { about : String
    , intro : String
    , section1 : String
    , section2 : String
    , section3 : String
    , section4a : String
    , section4b : String
    , section5 : String
    , section6 : String
    , section7 : String
    , conclusion : String
    , process : String
    }

type alias Flags =
    { files : FlagFiles
    , pages : FlagPages
    }
