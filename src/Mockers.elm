module Mockers exposing (..)

import Model exposing (Note, NoteContent(..))
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
            { todos = [{id = "1", text = "foo", done = False}, {id = "2", text = "bar", done = False}, {id = "3", text = "", done = False}]
            }
    }