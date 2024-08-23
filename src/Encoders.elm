module Encoders exposing (..)
import Model exposing (NewNoteData)
import Json.Encode


newNoteDataEncoder : NewNoteData -> Json.Encode.Value
newNoteDataEncoder newNoteData =
    Json.Encode.object
        [ ( "title", Json.Encode.string newNoteData.title )
        , ( "text", Json.Encode.string newNoteData.text )
        ]
