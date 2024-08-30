module Utils exposing (..)

import Model exposing (NewNoteData(..), Note, NoteContent(..))
import Time exposing (posixToMillis)


getCopyNotePayload : Note -> NewNoteData
getCopyNotePayload note =
    case note.content of
        TextNoteContent data ->
            NewTextNoteData
                { title = getCopyTitle note.title
                , text = data.text
                }

        TodoNoteContent data ->
            NewTodoNoteData
                { title = getCopyTitle note.title
                , todos = data.todos
                }


getCopyTitle title =
    title ++ " (copy)"


newestFirst : Note -> Note -> Order
newestFirst noteA noteB =
    let
        updatedAtA =
            noteA.updatedAt |> posixToMillis

        updatedAtB =
            noteB.updatedAt |> posixToMillis
    in
    case compare updatedAtA updatedAtB of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT
