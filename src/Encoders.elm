module Encoders exposing (..)

import Json.Encode
import Model exposing (NewNoteData(..), Note, NoteContent(..), Todo)
import Pages.Login.Model
import Time exposing (posixToMillis)


newNoteDataEncoder : NewNoteData -> Json.Encode.Value
newNoteDataEncoder newNoteData =
    case newNoteData of
        NewTextNoteData data ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "text" )
                , ( "title", Json.Encode.string data.title )
                , ( "text", Json.Encode.string data.text )
                ]

        NewTodoNoteData data ->
            Json.Encode.object
                [ ( "type", Json.Encode.string "todo" )
                , ( "title", Json.Encode.string data.title )
                , ( "todos", Json.Encode.list encodeTodo data.todos )
                ]


encodeTodo : Todo -> Json.Encode.Value
encodeTodo todo =
    Json.Encode.object
        [ ( "id", Json.Encode.string todo.id )
        , ( "text", Json.Encode.string todo.text )
        , ( "done", Json.Encode.bool todo.done )
        ]


noteEncoder : Note -> Json.Encode.Value
noteEncoder note =
    Json.Encode.object
        [ ( "id", Json.Encode.string note.id )
        , ( "type"
          , Json.Encode.string
                (case note.content of
                    TextNoteContent _ ->
                        "text"

                    TodoNoteContent _ ->
                        "todo"
                )
          )
        , ( "createdAt", Json.Encode.int (posixToMillis note.createdAt) )
        , ( "updatedAt", Json.Encode.int (posixToMillis note.updatedAt) )
        , ( "version", Json.Encode.int note.version )
        , ( "title", Json.Encode.string note.title )
        , ( "content", noteContentEncoder note.content )
        ]


noteContentEncoder : NoteContent -> Json.Encode.Value
noteContentEncoder noteContent =
    case noteContent of
        TextNoteContent data ->
            Json.Encode.object
                [ ( "text", Json.Encode.string data.text )
                ]

        TodoNoteContent data ->
            Json.Encode.object
                [ ( "todos", Json.Encode.list todoEncoder data.todos )
                ]


todoEncoder : Todo -> Json.Encode.Value
todoEncoder todo =
    Json.Encode.object
        [ ( "id", Json.Encode.string todo.id )
        , ( "text", Json.Encode.string todo.text )
        , ( "done", Json.Encode.bool todo.done )
        ]


loginDataEncoder : Pages.Login.Model.Model -> Json.Encode.Value
loginDataEncoder { username, password } =
    Json.Encode.object
        [ ( "username", Json.Encode.string username )
        , ( "password", Json.Encode.string password )
        ]
