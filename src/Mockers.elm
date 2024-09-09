module Mockers exposing
    ( mockDndData
    , mockedTextNote
    , mockedTodoNote
    )

import DnDList
import Model exposing (DndData, Note, NoteContent(..), Todo)
import Time exposing (millisToPosix)


mockedTextNote : Note
mockedTextNote =
    { id = "1"
    , createdAt = millisToPosix 1
    , updatedAt = millisToPosix 1
    , version = 1
    , title = "fake title"
    , content =
        TextNoteContent
            { text = "fake text"
            }
    }


mockedTodoNote : Note
mockedTodoNote =
    { id = "1"
    , createdAt = millisToPosix 1
    , updatedAt = millisToPosix 1
    , version = 1
    , title = "fake title"
    , content =
        TodoNoteContent
            { todos = [ { id = "1", text = "foo", done = False }, { id = "2", text = "bar", done = False }, { id = "3", text = "", done = False } ]
            }
    }


dndConfig : DnDList.Config Todo
dndConfig =
    { beforeUpdate = \_ _ list -> list
    , movement = DnDList.Vertical
    , listen = DnDList.OnDrag
    , operation = DnDList.Swap
    }


dndSystem : (DnDList.Msg -> msg) -> DnDList.System Todo msg
dndSystem msgConverter =
    DnDList.create dndConfig msgConverter


mockDndData : (DnDList.Msg -> msg) -> DndData msg
mockDndData msgConverter =
    let
        system =
            dndSystem msgConverter
    in
    DndData system system.model
