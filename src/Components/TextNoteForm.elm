module Components.TextNoteForm exposing (textNoteForm)

import Html exposing (Html)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput)
import HtmlUtils exposing (testId)
import Styleguide.TextArea exposing (textArea)
import Styleguide.TextBox exposing (textBox)


textNoteForm : { title : String, text : String, updateTitleMsg : String -> msg, updateTextMsg : String -> msg } -> List (Html msg)
textNoteForm { title, text, updateTextMsg, updateTitleMsg } =
    [ textBox { labelAttributes = [ testId "note-title-input", onInput updateTitleMsg ], inputAttributes = [ value title ] } "Title" identity
    , textArea { labelAttributes = [ testId "note-text-input", onInput updateTextMsg ], inputAttributes = [ value text ] } "content"
    ]
