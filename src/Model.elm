module Model exposing (..)

import Time


type alias Id =
    String


type alias Notes =
    List Note


type alias Note =
    { id : Id
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    , version : Int
    , title : String
    , content : NoteContent
    }


type NoteContent
    = TextNoteContent TextNoteContentData
    | TodoNoteContent TodoNoteContentData


type alias TextNoteContentData =
    { text : String
    }


updateNoteText note text =
    case note.content of
        TextNoteContent data ->
            { note | content = TextNoteContent { data | text = text } }

        TodoNoteContent _ ->
            note


getNoteText note =
    case note.content of
        TextNoteContent data ->
            data.text

        TodoNoteContent _ ->
            ""


updateTodoDone note todoId done =
    case note.content of
        TextNoteContent _ ->
            note

        TodoNoteContent data ->
            { note
                | content =
                    TodoNoteContent
                        { data
                            | todos =
                                List.map
                                    (\todo ->
                                        if todo.id == todoId then
                                            { todo | done = done }

                                        else
                                            todo
                                    )
                                    data.todos
                        }
            }


updateTodoText note todoId text =
    case note.content of
        TextNoteContent _ ->
            note

        TodoNoteContent data ->
            { note
                | content =
                    TodoNoteContent
                        { data
                            | todos = updateTodosWitText { todoId = todoId, todos = data.todos, text = text }
                        }
            }


type alias TodoNoteContentData =
    { todos : List Todo
    }


type alias Todo =
    { id : Id
    , text : String
    , done : Bool
    }


type NewNoteData
    = NewTextNoteData
        { title : String
        , text : String
        }
    | NewTodoNoteData
        { title : String
        , todos : List Todo
        }


updateNewNoteTitle newNoteData title =
    case newNoteData of
        NewTextNoteData data ->
            NewTextNoteData { data | title = title }

        NewTodoNoteData data ->
            NewTodoNoteData { data | title = title }


updateNewNoteText newNoteData text =
    case newNoteData of
        NewTextNoteData data ->
            NewTextNoteData { data | text = text }

        NewTodoNoteData data ->
            NewTodoNoteData data


updateNewTodoDone newTodoData todoId done =
    case newTodoData of
        NewTextNoteData _ ->
            newTodoData

        NewTodoNoteData data ->
            NewTodoNoteData
                { data
                    | todos =
                        List.map
                            (\todo ->
                                if todo.id == todoId then
                                    { todo | done = done }

                                else
                                    todo
                            )
                            data.todos
                }


updateNewTodoText newTodoData todoId text =
    case newTodoData of
        NewTextNoteData _ ->
            newTodoData

        NewTodoNoteData data ->
            let
                lastTodo =
                    List.reverse data.todos |> List.head

                newTodo =
                    [ { id = String.fromInt (List.length data.todos + 1), text = "", done = False } ]

                newTodoToAppend =
                    case lastTodo of
                        Nothing ->
                            newTodo

                        Just todo ->
                            if todo.text == "" then
                                []

                            else
                                newTodo
            in
            NewTodoNoteData
                { data
                    | todos = updateTodosWitText { todoId = todoId, todos = data.todos, text = text }
                }


updateTodosWitText { todoId, text, todos } =
    let
        updatedTodos =
            List.map
                (\todo ->
                    if todo.id == todoId then
                        { todo | text = text }

                    else
                        todo
                )
                todos

        lastTodo =
            List.reverse updatedTodos |> List.head

        newTodo =
            [ { id = String.fromInt (List.length updatedTodos + 1), text = "", done = False } ]

        newTodoToAppend =
            case lastTodo of
                Nothing ->
                    newTodo

                Just todo ->
                    if todo.text == "" then
                        []

                    else
                        newTodo
    in
    updatedTodos ++ newTodoToAppend
