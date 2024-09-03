module Components.TodoNoteForm exposing (totdoNoteForm)

import Html exposing (Html, div, input)
import Html.Attributes exposing (checked, class, type_, value)
import Html.Events exposing (onCheck, onInput)
import HtmlUtils exposing (testId)
import Model exposing (Id, Todo)
import Styleguide.TextBox exposing (textBox)


totdoNoteForm : { title : String, todos : List Todo, updateTitleMsg : String -> msg, updateTodoDoneMsg : Id -> Bool -> msg, updateTodoTextMsg : Id -> String -> msg } -> List (Html msg)
totdoNoteForm { title, todos, updateTitleMsg, updateTodoDoneMsg, updateTodoTextMsg } =
    textBox { labelAttributes = [ testId "note-title-input", onInput updateTitleMsg ], inputAttributes = [ value title ] } "Title" identity
        :: List.map (singleTodo updateTodoDoneMsg updateTodoTextMsg) todos


singleTodo : (Id -> Bool -> msg) -> (Id -> String -> msg) -> Todo -> Html msg
singleTodo updateDone updateText todo =
    div
        [ class "single-todo", testId "single-todo" ]
        [ input
            [ type_ "checkbox", checked todo.done, onCheck (updateDone todo.id), testId "note-todo-done-input" ]
            []
        , input [ value todo.text, onInput (updateText todo.id), testId "note-todo-text-input" ] []
        ]
