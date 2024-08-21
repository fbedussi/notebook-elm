port module Backend exposing (..)

import Json.Decode exposing (Value)
import Model exposing (Id)


port addNote : String -> Cmd msg


port getNotes : () -> Cmd msg


port gotNotes : (Value -> msg) -> Sub msg


port getNote : Id -> Cmd msg


port saveNote : Value -> Cmd msg


port gotNote : (Value -> msg) -> Sub msg


port delNote : Id -> Cmd msg
