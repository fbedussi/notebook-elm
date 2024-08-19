module Pages.Single.EditNoteForm exposing (..)

import Html exposing (form)
import Html.Attributes exposing (attribute, disabled, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Model exposing (Note)
import Pages.Single.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
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
            in
            form
                [ attribute "data-testid" "edit-note-form", onSubmit SaveNote ]
                [ textBox { labelAttributes = [ attribute "data-testid" "note-title-input", onInput UpdateNewNoteTitle ], inputAttributes = [ value note.title ] } "Title"
                , textArea { labelAttributes = [ attribute "data-testid" "note-text-input", onInput UpdateNewNoteText ], inputAttributes = [ value note.text ] } "content"
                , button [ attribute "data-testid" "save-note-btn", type_ "submit", disabled isPristine ] [ saveIcon ]
                ]
