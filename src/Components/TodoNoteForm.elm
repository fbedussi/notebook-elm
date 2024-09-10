module Components.TodoNoteForm exposing (totdoNoteForm)

import DnDList
import Html exposing (Html, div, input, span, text)
import Html.Attributes exposing (checked, class, id, type_, value)
import Html.Events exposing (onCheck, onInput)
import HtmlUtils exposing (testId)
import Model exposing (DndData, Id, Todo)
import Styleguide.Icons.Drag exposing (dragIcon)
import Styleguide.TextBox exposing (textBox)


totdoNoteForm :
    DndData msg
    ->
        { title : String
        , todos : List Todo
        , updateTitleMsg : String -> msg
        , updateTodoDoneMsg : Id -> Bool -> msg
        , updateTodoTextMsg : Id -> String -> msg
        }
    -> List (Html msg)
totdoNoteForm dndData ({ title, todos } as props) =
    textBox
        { labelAttributes =
            [ testId "note-title-input"
            , onInput props.updateTitleMsg
            ]
        , inputAttributes = [ value title ]
        }
        "Title"
        identity
        :: List.indexedMap (singleTodoDndWrapper dndData props) todos
        ++ [ ghostView (dndData.dndSystem.ghostStyles dndData.dndModel) (getDraggedTodo dndData todos) ]


getDraggedTodo { dndSystem, dndModel } todos =
    dndSystem.info dndModel
        |> Maybe.andThen (\{ dragIndex } -> todos |> List.drop dragIndex |> List.head)


singleTodoDndWrapper { dndSystem, dndModel } { updateTodoDoneMsg, updateTodoTextMsg } index todo =
    let
        defaultProps =
            { updateTodoDoneMsg = updateTodoDoneMsg, updateTodoTextMsg = updateTodoTextMsg, todo = todo, dndAttributes = [] }
    in
    case dndSystem.info dndModel of
        Just { dragIndex } ->
            if dragIndex /= index then
                singleTodo { defaultProps | dndAttributes = dndSystem.dropEvents index todo.id }

            else
                singleTodo defaultProps

        Nothing ->
            singleTodo { defaultProps | dndAttributes = dndSystem.dragEvents index todo.id }


ghostView : List (Html.Attribute msg) -> Maybe Todo -> Html.Html msg
ghostView ghostStyles maybeDragTodo =
    case maybeDragTodo of
        Just todo ->
            div
                (class "single-todo" :: ghostStyles)
                [ dragIcon
                , input
                    [ type_ "checkbox", checked todo.done ]
                    []
                , input [ value todo.text ] []
                ]

        Nothing ->
            text ""


singleTodo :
    { todo : Todo
    , updateTodoDoneMsg : Id -> Bool -> msg
    , updateTodoTextMsg : Id -> String -> msg
    , dndAttributes : List (Html.Attribute msg)
    }
    -> Html msg
singleTodo { todo, updateTodoDoneMsg, updateTodoTextMsg, dndAttributes } =
    div
        [ class "single-todo"
        , testId "single-todo"
        , id todo.id
        ]
        [ div
            dndAttributes
            [ dragIcon ]
        , input
            [ type_ "checkbox"
            , checked todo.done
            , onCheck (updateTodoDoneMsg todo.id)
            , testId "note-todo-done-input"
            ]
            []
        , input
            [ value todo.text
            , onInput (updateTodoTextMsg todo.id)
            , testId "note-todo-text-input"
            ]
            []
        ]
