module Decoders exposing (..)

import Json.Decode exposing (Decoder, bool, int, map, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Model exposing (Note, NoteContent(..), TextNoteContentData, Todo, TodoNoteContentData)
import Pages.List.Model exposing (Msg(..))
import Time exposing (Posix, millisToPosix)


notesDecoder : Decoder (List Note)
notesDecoder =
    Json.Decode.list noteDecoder


noteDecoder : Decoder Note
noteDecoder =
    succeed Note
        |> required "id" string
        |> required "createdAt" decodePosix
        |> required "updatedAt" decodePosix
        |> required "version" int
        |> required "title" string
        |> required "content" noteContentDecoder


noteContentDecoder : Decoder NoteContent
noteContentDecoder =
    Json.Decode.oneOf
        [ textNoteContentDecoder
            |> map TextNoteContent
        , todoNoteContentDecoder
            |> map TodoNoteContent
        ]


textNoteContentDecoder : Decoder TextNoteContentData
textNoteContentDecoder =
    succeed TextNoteContentData
        |> required "text" string


todoNoteContentDecoder : Decoder TodoNoteContentData
todoNoteContentDecoder =
    succeed TodoNoteContentData
        |> required "todos" (Json.Decode.list todoDecoder)


todoDecoder : Decoder Todo
todoDecoder =
    succeed Todo
        |> required "id" string
        |> required "text" string
        |> required "done" bool


decodePosix : Decoder Posix
decodePosix =
    int
        |> Json.Decode.map millisToPosix
