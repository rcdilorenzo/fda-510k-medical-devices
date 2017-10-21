module Models.Flags exposing (..)

type alias FlagFiles =
    { applicantCount : String
    , categoryCount : String
    , categoryVsDecisionCount : String
    , countryCode : String
    , decisionCount : String
    , deviceNounCount : String
    , expeditedReviewCount : String
    , yearVsDecisionOrthoCount : String
    , yearCount : String
    }

type alias FlagPages =
    { about : String
    , intro : String
    , section1 : String
    , section2 : String
    }

type alias Flags =
    { files : FlagFiles
    , pages : FlagPages
    }
