module Pages.List.AddNoteFormTest exposing (..)

import Expect
import Html exposing (div)
import Html.Attributes
import Main exposing (..)
import Model exposing (NewNoteData(..), Todo)
import Pages.List.AddNoteForm exposing (addNoteForm)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (disabled, tag)
import Mockers exposing (mockDndData)
import Pages.List.Model exposing (Msg(..))

mockedDndData =
    mockDndData SwapTodos
    
addNoteFormTest : Test
addNoteFormTest =
    describe "addNoteForm"
        [ test "it has the right fields" <|
            \_ ->
                addNoteForm mockedDndData (NewTextNoteData { title = "", text = "" }) True
                    |> (\( a, b ) ->
                            a ++ b
                       )
                    |> div []
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-title-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-text-input"
                        , Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "save-note-btn"
                        ]
        , test "the submit button is disabled if the form is empty" <|
            \_ ->
                addNoteForm mockedDndData (NewTextNoteData { title = "", text = "" }) True
                    |> (\( a, b ) ->
                            a ++ b
                       )
                    |> div []
                    |> Query.fromHtml
                    |> Query.find [ tag "button", Test.Html.Selector.attribute <| Html.Attributes.attribute "type" <| "submit" ]
                    |> Query.has [ disabled True ]
        ]
