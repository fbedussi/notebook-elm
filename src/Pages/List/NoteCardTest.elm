module Pages.List.NoteCardTest exposing (..)

import Main exposing (..)
import Mockers exposing (mockedTextNote)
import Pages.List.NoteCard exposing (noteCard)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import TestUtils exposing (testId)
import Mockers exposing (mockedTodoNote)
import Expect
import Test.Html.Selector exposing (tag)


addNoteFormTest : Test
addNoteFormTest =
    describe "noteCard"
        [ test "it has edit button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ testId "edit-btn" ]
        , test "it has the delete button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ testId "delete-note-btn" ]
        , test "it has the copy button" <|
            \_ ->
                noteCard mockedTextNote
                    |> Query.fromHtml
                    |> Query.has
                        [ testId "copy-note-btn" ]
        ]


todoNoteCardTest : Test
todoNoteCardTest = 
    describe "todo note card"
        [test "doesn't show the empty todo" <|
            \_ ->
                noteCard mockedTodoNote
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 2)
        ]