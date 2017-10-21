module Models.Flags exposing (..)

type alias FlagFiles =
    { applicantCount : String
    , categoryCount : String
    , categoryVsDecisionCount : String
    , countryCode : String
    , decisionCount : String
    , deviceNounCount : String
    , expeditedReviewCount : String
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
    }

type alias Flags =
    { files : FlagFiles
    , pages : FlagPages
    }
