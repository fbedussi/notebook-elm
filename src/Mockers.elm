module Mockers exposing (..)

import Model exposing (Note)
import Time exposing (millisToPosix)


mockNote : { title : Maybe String, text : Maybe String } -> Note
mockNote { title, text } =
    let
        fakeTitle =
            case title of
                Just t ->
                    t

                Nothing ->
                    "fake title"

        fakeText =
            case text of
                Just t ->
                    t

                Nothing ->
                    "fake text"
    in
    { id = "1"
    , title = fakeTitle
    , text = fakeText
    , createdAt = millisToPosix 1
    , updatedAt = millisToPosix 1
    }


mockedNote =
    mockNote { title = Nothing, text = Nothing }
