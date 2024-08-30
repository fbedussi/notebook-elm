module Pages.Single.EditNoteFormTest exposing (..)

import Html.Attributes
import Mockers exposing (mockedTextNote)
import Pages.Single.EditNoteForm exposing (editNoteForm)
import ProgramTest exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (disabled, tag)


editNoteFormTest : Test
editNoteFormTest =
    describe "editNoteForm"
        [ test "it has the right fields" <|
            \_ ->
                editNoteForm False (Just mockedTextNote)
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-title-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-text-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "save-note-btn"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "delete-note-btn"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "copy-note-btn"
                        ]
        , test "the submit button is disabled if the form is pristine" <|
            \_ ->
                editNoteForm False (Just mockedTextNote)
                    |> Query.fromHtml
                    |> Query.find [ tag "button", Test.Html.Selector.attribute <| Html.Attributes.attribute "type" <| "submit" ]
                    |> Query.has [ disabled True ]
        , test "the submit button is enabled if the form is dirty" <|
            \_ ->
                editNoteForm True (Just mockedTextNote)
                    |> Query.fromHtml
                    |> Query.find [ tag "button", Test.Html.Selector.attribute <| Html.Attributes.attribute "type" <| "submit" ]
                    |> Query.has [ disabled False ]
        ]
