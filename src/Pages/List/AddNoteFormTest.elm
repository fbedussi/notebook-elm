module Pages.List.AddNoteFormTest exposing (..)

import Html.Attributes
import Main exposing (..)
import Pages.List.AddNoteForm exposing (addNoteForm)
import ProgramTest exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (disabled, tag)


addNoteFormTest : Test
addNoteFormTest =
    describe "addNoteForm"
        [ test "it has the right fields" <|
            \_ ->
                addNoteForm { title = "", text = "" }
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-title-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-text-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "save-note-btn"
                        ]
        , test "the submit butto is disabled if the form is empty" <|
            \_ ->
                addNoteForm { title = "", text = "" }
                    |> Query.fromHtml
                    |> Query.find [ tag "button", Test.Html.Selector.attribute <| Html.Attributes.attribute "type" <| "submit" ]
                    |> Query.has [ disabled True ]
        ]
