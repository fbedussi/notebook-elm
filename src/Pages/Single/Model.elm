module Pages.Single.Model exposing (..)

import Model exposing (Note)
import Model exposing (Id)


type alias Model =
    { id : String
    , note : Maybe Note
    , error : Maybe String
    , isFormDirty : Bool
    , isCopyingNote: Bool
    }


type Msg
    = GotNote Note
    | SaveNote
    | GotError String
    | UpdateNewNoteTitle String
    | UpdateNewNoteText String
    | UpdateTodoDone Id Bool
    | UpdateTodoText Id String
    | DeleteNote Note
    | CopyNote Note
