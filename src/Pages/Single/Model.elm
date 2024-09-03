module Pages.Single.Model exposing (..)

import Model exposing (Id, Note)


type alias Model =
    { id : String
    , note : Maybe Note
    , error : Maybe String
    , isFormDirty : Bool
    , isCopyingNote : Bool
    }


type Msg
    = GotNote Note
    | SaveNote
    | GotError String
    | UpdateNoteTitle String
    | UpdateNoteText String
    | UpdateTodoDone Id Bool
    | UpdateTodoText Id String
    | DeleteNote Note
    | CopyNote Note
