module Decoders exposing (..)

import Json.Decode exposing (Decoder, int, string, succeed)
import Json.Decode.Pipeline exposing (required)
import Model exposing (Note)
import Pages.List.Model exposing (Msg(..))
import Time exposing (Posix, millisToPosix)


noteDecoder : Decoder Note
noteDecoder =
    succeed Note
        |> required "id" string
        |> required "title" string
        |> required "text" string
        |> required "createdAt" decodePosix
        |> required "updatedAt" decodePosix
        |> required "version" int


decodePosix : Decoder Posix
decodePosix =
    int
        |> Json.Decode.map millisToPosix


notesDecoder : Decoder (List Note)
notesDecoder =
    Json.Decode.list noteDecoder
