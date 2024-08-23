module Pages.List.Model exposing (..)

import Model exposing (Note, Notes, NewNoteData)


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
    | CopyNote Note
    | UpdateNewNoteTitle String
    | UpdateNewNoteText String
    | AddNote
    | GotNotes Notes
    | GotError String
