module Utils exposing (..)

import Model exposing (NewNoteData, Note)
import Time exposing (posixToMillis)


getCopyNotePayload : Note -> NewNoteData
getCopyNotePayload note =
    { title = note.title ++ " (copy)"
    , text = note.text
    }


newestFirst : { a | updatedAt : Time.Posix } -> { b | updatedAt : Time.Posix } -> Order
newestFirst noteA noteB =
    let
        updatedAtA =
            posixToMillis noteA.updatedAt

        updatedAtB =
            posixToMillis noteB.updatedAt
    in
    case compare updatedAtA updatedAtB of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
