module Pages.List.AddNoteForm exposing (..)

import Components.TextNoteForm exposing (textNoteForm)
import Components.TodoNoteForm exposing (totdoNoteForm)
import DnDList
import Html exposing (Html, div, form, input)
import Html.Attributes exposing (attribute, checked, class, disabled, id, style, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import HtmlUtils exposing (testId)
import Model exposing (DndData, Id, NewNoteData(..), Todo)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Save exposing (saveIcon)
import Styleguide.RadioGroup exposing (radioGroup)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)


addNoteForm : DndData Msg -> NewNoteData -> Bool -> ( List (Html Msg), List (Html Msg) )
addNoteForm dndData newNoteData isPristine =
    let
        selectedNoteType =
            case newNoteData of
                NewTextNoteData _ ->
                    "text"

                NewTodoNoteData _ ->
                    "todo"

        noteForm =
            case newNoteData of
                NewTextNoteData { title, text } ->
                    textNoteForm
                        { title = title
                        , text = text
                        , updateTitleMsg = UpdateNewNoteTitle
                        , updateTextMsg = UpdateNewNoteText
                        }

                NewTodoNoteData { title, todos } ->
                    totdoNoteForm
                        dndData
                        { title = title
                        , todos = todos
                        , updateTitleMsg = UpdateNewNoteTitle
                        , updateTodoDoneMsg = UpdateTodoDone
                        , updateTodoTextMsg = UpdateTodoText
                        }

        formId =
            "add-note-form"
    in
    ( [ form
            [ id formId, testId "add-note-form", onSubmit AddNote, class "note-form" ]
            (radioGroup
                { groupLabel = "Select note type:"
                , groupName = "note-type"
                , options =
                    [ { value = "text"
                      , label = "text"
                      }
                    , { value = "todo"
                      , label = "todo"
                      }
                    ]
                }
                (\noteType selected -> SetNoteType (buildNewNoteData noteType selected))
                selectedNoteType
                :: noteForm
            )
      ]
    , [ button [ attribute "form" formId, testId "save-note-btn", type_ "submit", disabled isPristine ] [ saveIcon ]
      ]
    )


buildNewNoteData noteType selected =
    if noteType == "todo" && selected == True then
        NewTodoNoteData { title = "", todos = [ { id = "1", text = "", done = False } ] }

    else
        NewTextNoteData { title = "", text = "" }
