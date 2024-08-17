module Pages.List.Model exposing (..)

import Model exposing (Notes)


type alias NewNoteData =
    { title : String
    , text : String
    }


type alias Model =
    { notes : Notes
    , addNoteFormOpen : Bool
    , newNoteData : NewNoteData
    , error : Maybe String
    }


type Msg
    = OpenAddNoteForm
    | CloseAddNoteForm
    | UpdateNewNoteTitle String
    | UpdateNewNoteText String
    | AddNote
    | GotNotes Notes
    | GotError String
