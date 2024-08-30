module Pages.List.NoteCardTest exposing (..)

import Html.Attributes
import Main exposing (..)
import Mockers exposing (mockedTextNote)
import Pages.List.NoteCard exposing (noteCard)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (disabled, tag)


addNoteFormTest : Test
addNoteFormTest =
    describe "noteCard"
        [ test "it has edit button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "edit-btn" ]
        , test "it has the delete button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "delete-note-btn" ]
        , test "it has the copy button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "copy-note-btn" ]
        ]
