module Models.Flags exposing (..)

type alias FlagFiles =
    { applicantCount : String
    , categoryCount : String
    , categoryVsDecisionCount : String
    , countryCode : String
    , decisionCount : String
    , deviceNounCount : String
    , expeditedReviewCount : String
    , reviewCommitteeVsDecisionCount : String
    , yearCount : String
    }

type alias FlagPages =
    { about : String
    , intro : String
    }

type alias Flags =
    { files : FlagFiles
    , pages : FlagPages
    }
