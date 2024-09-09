module Pages.List.Model exposing (..)

import DnDList
import Model exposing (Id, NewNoteData, Note, Notes)


type alias Model =
    { notes : Notes
    , addNoteFormOpen : Bool
    , newNoteData : NewNoteData
    , newNoteFormPristine : Bool
    , noteToDelete : Maybe Note
    , error : Maybe String
    , dnd : DnDList.Model
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
    | SetNoteType NewNoteData
    | UpdateTodoDone Id Bool
    | UpdateTodoText Id String
    | CheckShortcuts Char
    | SwapTodos DnDList.Msg
