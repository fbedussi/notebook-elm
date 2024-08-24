port module Backend exposing (addNewNote, delNote, getNote, getNotes, gotNote, gotNotes, saveNote)

import Encoders exposing (newNoteDataEncoder)
import Json.Decode exposing (Value)
import Json.Encode
import Model exposing (Id)


port addNote : String -> Cmd msg


addNewNote newNotePayload =
    newNotePayload |> newNoteDataEncoder |> Json.Encode.encode 0 |> addNote


port getNotes : () -> Cmd msg


port gotNotes : (Value -> msg) -> Sub msg


port getNote : Id -> Cmd msg


port saveNote : Value -> Cmd msg


port gotNote : (Value -> msg) -> Sub msg


port delNote : Id -> Cmd msg
