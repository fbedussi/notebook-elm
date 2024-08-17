module Pages.List.MainTest exposing (..)

import Expect
import Html exposing (div)
import Html.Attributes
import Http exposing (Expect)
import Mockers exposing (mockNote)
import Pages.List.Main exposing (init, update, view)
import Pages.List.Model exposing (Msg(..))
import ProgramTest exposing (..)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag)


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
                        mockNote { title = Nothing, text = Nothing }
                in
                div [] (view { model | notes = [ note ] })
                    |> Query.fromHtml
                    |> Query.find
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note" ]
                    |> Query.has
                        [ Test.Html.Selector.text note.title
                        , Test.Html.Selector.text note.text
                        ]
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
