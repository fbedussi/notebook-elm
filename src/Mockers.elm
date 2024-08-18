module Mockers exposing (..)

import Model exposing (Note)
import Time exposing (millisToPosix)


mockedNote : Note
mockedNote =
    { id = "1"
    , title = "fake title"
    , text = "fake text"
    , createdAt = millisToPosix 1
    , updatedAt = millisToPosix 1
    }
