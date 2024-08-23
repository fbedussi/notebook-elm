port module Backend exposing (addNote, delNote, getNote, getNotes, gotNote, gotNotes, saveNote)

import Encoders exposing (newNoteDataEncoder)
import Json.Decode exposing (Value)
import Json.Encode
import Model exposing (Id)


port addNotePort : String -> Cmd msg


addNote newNotePayload =
    newNotePayload |> newNoteDataEncoder |> Json.Encode.encode 0 |> addNotePort


port getNotes : () -> Cmd msg


port gotNotes : (Value -> msg) -> Sub msg


port getNote : Id -> Cmd msg


port saveNote : Value -> Cmd msg


port gotNote : (Value -> msg) -> Sub msg


port delNote : Id -> Cmd msg
