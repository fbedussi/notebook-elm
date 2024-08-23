module Pages.Single.EditNoteForm exposing (..)

import Html exposing (div, form)
import Html.Attributes exposing (attribute, class, disabled, style, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Model exposing (Note)
import Pages.Single.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Delete exposing (deleteIcon)
import Styleguide.Icons.Save exposing (saveIcon)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)
import Html.Events exposing (onClick)


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
                , div
                    [ style "display" "flex", style "justfy-content" "space-around", style "gap" "1rem" ]
                    [ button [ attribute "data-testid" "delete-note-btn", class "outline", class "secondary", onClick (DeleteNote note) ] [ deleteIcon ]
                    , button [ attribute "data-testid" "save-note-btn", type_ "submit", disabled isPristine ] [ saveIcon ]
                    ]
                ]
