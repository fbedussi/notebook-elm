module Styleguide.SingleTodo exposing (..)
import Model exposing (Todo)
import Html exposing (Html)
import HtmlUtils exposing (testId)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value)
import Html exposing (input)
import Html.Attributes exposing (type_)
import Html.Attributes exposing (checked)
import Html.Events exposing (onCheck)
import Html exposing (div)
import Model exposing (Id)
import Html.Attributes exposing (class)

singleTodo : (Id -> Bool -> msg) -> (Id -> String -> msg) -> Todo -> Html msg
singleTodo updateDone updateText todo =
    div
        [ class "single-todo", testId "single-todo" ]
        [ input
            [ type_ "checkbox", checked todo.done, onCheck (updateDone todo.id) ]
            []
        , input [ value todo.text, onInput (updateText todo.id), testId "note-todo-text-input" ] []
        ]
