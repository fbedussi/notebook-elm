module Pages.List.MainTest exposing (..)

import Expect
import Html exposing (div)
import Html.Attributes
import Mockers exposing (mockedNote)
import Pages.List.Main exposing (init, view)
import Pages.List.Model exposing (Msg(..))
import ProgramTest exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag)
import Time exposing (millisToPosix)


model =
    init ()


listPageTest : Test
listPageTest =
    describe "List page"
        [ test "it has an 'add note' button" <|
            \_ ->
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.has [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "add-note-btn" ]
        , test "the 'new note' form is hidden by default" <|
            \_ ->
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.find [ tag "dialog" ]
                    |> Query.hasNot [ Test.Html.Selector.attribute <| Html.Attributes.attribute "open" <| "true" ]
        , test "it shows saved notes" <|
            \_ ->
                let
                    note =
                        mockedNote
                in
                div [] (view { model | notes = [ note ] })
                    |> Query.fromHtml
                    |> Query.find
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note" ]
                    |> Query.has
                        [ Test.Html.Selector.text note.title
                        , Test.Html.Selector.text note.text
                        ]
        , test "the notes are sorted by modification date" <|
            \_ ->
                let
                    note1 =
                        { mockedNote | title = "note1" }

                    note2 =
                        { mockedNote | id = "2", title = "note2", updatedAt = millisToPosix 2 }
                in
                div [] (view { model | notes = [ note1, note2 ] })
                    |> Query.fromHtml
                    |> Query.findAll
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note" ]
                    |> Query.first
                    |> Query.has [ Test.Html.Selector.text "note2" ]
        , test "when the note is saved the add note modal content is cleared out" <|
            \_ ->
                let
                    dirtyNewNoteData =
                        { title = "old title", text = "old text" }

                    ( updatedModel, _ ) =
                        Pages.List.Main.update AddNote { model | newNoteData = dirtyNewNoteData }

                    newNoteData =
                        updatedModel.newNoteData
                in
                Expect.equal { title = "", text = "" } newNoteData
        ]
