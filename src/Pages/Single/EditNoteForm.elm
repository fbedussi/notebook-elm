module Pages.Single.EditNoteForm exposing (..)

import Html exposing (Html, div, form, input)
import Html.Attributes exposing (attribute, checked, class, disabled, id, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import Model exposing (Note, NoteContent(..), Todo)
import Pages.Single.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Copy exposing (copyIcon)
import Styleguide.Icons.Delete exposing (deleteIcon)
import Styleguide.Icons.Save exposing (saveIcon)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)


editNoteForm : Bool -> Maybe Note -> Html.Html Msg
editNoteForm isDirty maybeNote =
    case maybeNote of
        Nothing ->
            form [] []

        Just note ->
            let
                isPristine =
                    not isDirty

                formId =
                    "edit-note-form"

                content =
                    case note.content of
                        TextNoteContent { text } ->
                            textContentEditor text

                        TodoNoteContent { todos } ->
                            todosContentEditor todos
            in
            div
                []
                [ form
                    [ id formId, attribute "data-testid" "edit-note-form", onSubmit SaveNote ]
                    [ textBox { labelAttributes = [ attribute "data-testid" "note-title-input", onInput UpdateNewNoteTitle ], inputAttributes = [ value note.title ] } "Title"
                    , content
                    ]
                , div
                    [ style "display" "flex", style "justfy-content" "space-around", style "gap" "1rem" ]
                    [ button [ attribute "data-testid" "delete-note-btn", class "outline", class "secondary", onClick (DeleteNote note) ] [ deleteIcon ]
                    , button [ attribute "data-testid" "copy-note-btn", class "outline", onClick (CopyNote note) ] [ copyIcon ]
                    , button [ attribute "data-testid" "save-note-btn", type_ "submit", attribute "form" formId, disabled isPristine ] [ saveIcon ]
                    ]
                ]


textContentEditor noteText =
    textArea { labelAttributes = [ attribute "data-testid" "note-text-input", onInput UpdateNewNoteText ], inputAttributes = [ value noteText ] } "content"


todosContentEditor : List Todo -> Html Msg
todosContentEditor todos =
    div
        []
        (List.map todoContentEditor todos)


todoContentEditor : Todo -> Html Msg
todoContentEditor todo =
    div
        []
        [ input
            [ type_ "checkbox", checked todo.done, onCheck (UpdateTodoDone todo.id) ]
            []
        , input
            [ type_ "text", value todo.text, onInput (UpdateTodoText todo.id) ]
            []
        ]
