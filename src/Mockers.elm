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
