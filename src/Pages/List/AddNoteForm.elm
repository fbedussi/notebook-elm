module Pages.List.AddNoteForm exposing (..)

import Html exposing (Html, div, form, input)
import Html.Attributes exposing (attribute, checked, disabled, id, type_, value)
import Html.Events exposing (onCheck, onInput, onSubmit)
import HtmlUtils exposing (testId)
import Model exposing (NewNoteData(..), Todo)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Save exposing (saveIcon)
import Styleguide.RadioGroup exposing (radioGroup)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)


addNoteForm : NewNoteData -> Bool -> ( List (Html Msg), List (Html Msg) )
addNoteForm newNoteData isPristine =
    let
        selectedNoteType =
            case newNoteData of
                NewTextNoteData _ ->
                    "text"

                NewTodoNoteData _ ->
                    "todo"

        noteForm =
            case newNoteData of
                NewTextNoteData newTextNoteData ->
                    textNoteForm newTextNoteData

                NewTodoNoteData newTodoNoteData ->
                    totdoNoteForm newTodoNoteData

        formId =
            "add-note-form"
    in
    ( [ form
            [ id formId, testId "add-note-form", onSubmit AddNote ]
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


textNoteForm : { title : String, text : String } -> List (Html Msg)
textNoteForm newTextNoteData =
    [ textBox { labelAttributes = [ testId "note-title-input", onInput UpdateNewNoteTitle ], inputAttributes = [ value newTextNoteData.title ] } "Title"
    , textArea { labelAttributes = [ testId "note-text-input", onInput UpdateNewNoteText ], inputAttributes = [ value newTextNoteData.text ] } "content"
    ]


totdoNoteForm : { title : String, todos : List Todo } -> List (Html Msg)
totdoNoteForm { title, todos } =
    textBox { labelAttributes = [ testId "note-title-input", onInput UpdateNewNoteTitle ], inputAttributes = [ value title ] } "Title"
        :: List.map todoLine todos


todoLine : Todo -> Html Msg
todoLine todo =
    div
        []
        [ input
            [ type_ "checkbox", checked todo.done, onCheck (UpdateTodoDone todo.id) ]
            []
        , input [ value todo.text, onInput (UpdateTodoText todo.id), testId "note-todo-text-input" ] []
        ]
