module Pages.List.AddNoteForm exposing (..)

import Html exposing (form, text)
import Html.Attributes exposing (attribute, disabled, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)


addNoteForm : { title : String, text : String } -> Html.Html Msg
addNoteForm newNoteData =
    let
        isPristine =
            (newNoteData.title == "") && (newNoteData.text == "")
    in
    form
        [ attribute "data-testid" "add-note-form", onSubmit AddNote ]
        [ textBox { labelAttributes = [ attribute "data-testid" "note-title-input", onInput UpdateNewNoteTitle ], inputAttributes = [ value newNoteData.title ] } "Title"
        , textArea { labelAttributes = [ attribute "data-testid" "note-text-input", onInput UpdateNewNoteText ], inputAttributes = [ value newNoteData.text ] } "content"
        , button [ attribute "data-testid" "save-note-btn", type_ "submit", disabled isPristine ] [ text "save" ]
        ]
