module Pages.Single.Model exposing (..)

import Model exposing (Note)


type alias Model =
    { id : String
    , note : Maybe Note
    , error : Maybe String
    , isFormDirty: Bool
    }


type Msg
    = GotNote Note
    | SaveNote
    | GotError String
    | UpdateNewNoteTitle String
    | UpdateNewNoteText String
