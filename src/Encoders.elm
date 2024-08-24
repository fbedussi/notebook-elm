module Encoders exposing (..)

import Json.Encode
import Model exposing (NewNoteData, Note)
import Pages.Login.Model
import Time exposing (posixToMillis)


newNoteDataEncoder : NewNoteData -> Json.Encode.Value
newNoteDataEncoder newNoteData =
    Json.Encode.object
        [ ( "title", Json.Encode.string newNoteData.title )
        , ( "text", Json.Encode.string newNoteData.text )
        ]


noteEncoder : Note -> Json.Encode.Value
noteEncoder note =
    Json.Encode.object
        [ ( "id", Json.Encode.string note.id )
        , ( "title", Json.Encode.string note.title )
        , ( "text", Json.Encode.string note.text )
        , ( "createdAt", Json.Encode.int (posixToMillis note.createdAt) )
        , ( "updatedAt", Json.Encode.int (posixToMillis note.updatedAt) )
        , ( "version", Json.Encode.int note.version )
        ]


loginDataEncoder : Pages.Login.Model.Model -> Json.Encode.Value
loginDataEncoder { username, password } =
    Json.Encode.object
        [ ( "username", Json.Encode.string username )
        , ( "password", Json.Encode.string password )
        ]
