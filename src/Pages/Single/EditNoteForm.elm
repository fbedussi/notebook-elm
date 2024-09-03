module Pages.Single.EditNoteForm exposing (..)

import Components.TextNoteForm exposing (textNoteForm)
import Components.TodoNoteForm exposing (totdoNoteForm)
import Html exposing (Html, div, form, input)
import Html.Attributes exposing (attribute, checked, class, disabled, id, style, type_, value)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)
import HtmlUtils exposing (testId)
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

                formContent =
                    case note.content of
                        TextNoteContent { text } ->
                            textNoteForm
                                { title = note.title
                                , text = text
                                , updateTitleMsg = UpdateNoteTitle
                                , updateTextMsg = UpdateNoteText
                                }

                        TodoNoteContent { todos } ->
                            totdoNoteForm
                                { title = note.title
                                , todos = todos
                                , updateTitleMsg = UpdateNoteTitle
                                , updateTodoDoneMsg = UpdateTodoDone
                                , updateTodoTextMsg = UpdateTodoText
                                }
            in
            div
                []
                [ form
                    [ id formId, testId "edit-note-form", onSubmit SaveNote, class "note-form" ]
                    (formContent
                        ++ [ div
                                [ style "display" "flex", style "justfy-content" "space-around", style "gap" "1rem" ]
                                [ button [ testId "delete-note-btn", type_ "button", class "outline", class "secondary", onClick (DeleteNote note) ] [ deleteIcon ]
                                , button [ testId "copy-note-btn", type_ "button", class "outline", onClick (CopyNote note) ] [ copyIcon ]
                                , button [ testId "save-note-btn", type_ "submit", attribute "form" formId, disabled isPristine ] [ saveIcon ]
                                ]
                           ]
                    )
                ]


textContentEditor noteText =
    textArea { labelAttributes = [ attribute "data-testid" "note-text-input", onInput UpdateNoteText ], inputAttributes = [ value noteText ] } "content"
