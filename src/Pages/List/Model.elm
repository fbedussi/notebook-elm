module Pages.List.Model exposing (..)

import Model exposing (Id, Note, Notes)


type alias NewNoteData =
    { title : String
    , text : String
    }


type alias Model =
    { notes : Notes
    , addNoteFormOpen : Bool
    , newNoteData : NewNoteData
    , noteToDelete : Maybe Note
    , error : Maybe String
    }


type Msg
    = OpenAddNoteForm
    | CloseAddNoteForm
    | DialogClosed ()
    | DeleteNote Note
    | UpdateNewNoteTitle String
    | UpdateNewNoteText String
    | AddNote
    | GotNotes Notes
    | GotError String
