module Pages.List.AddNoteFormTest exposing (..)

import Expect
import Html exposing (div)
import Html.Attributes
import Main exposing (..)
import Model exposing (NewNoteData(..), Todo)
import Pages.List.AddNoteForm exposing (addNoteForm, totdoNoteForm)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (disabled, tag)


addNoteFormTest : Test
addNoteFormTest =
    describe "addNoteForm"
        [ test "it has the right fields" <|
            \_ ->
                addNoteForm (NewTextNoteData { title = "", text = "" }) True
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
                addNoteForm (NewTextNoteData { title = "", text = "" }) True
                    |> (\( a, b ) ->
                            a ++ b
                       )
                    |> div []
                    |> Query.fromHtml
                    |> Query.find [ tag "button", Test.Html.Selector.attribute <| Html.Attributes.attribute "type" <| "submit" ]
                    |> Query.has [ disabled True ]
        ]


totdoNoteFormTest =
    describe "totdoNoteForm"
        [ test "it has the title" <|
            \_ ->
                let
                    title =
                        "title"
                in
                div
                    []
                    (totdoNoteForm
                        { title = title, todos = [] }
                    )
                    |> Query.fromHtml
                    |> Query.has [ Test.Html.Selector.attribute <| Html.Attributes.attribute "value" <| title ]
        , test "it has a text input for every todo" <|
            \_ ->
                let
                    title =
                        "title"

                    todos : List Todo
                    todos =
                        [ Todo "1" "1" False, Todo "2" "2" False ]
                in
                div
                    []
                    (totdoNoteForm
                        { title = title, todos = todos }
                    )
                    |> Query.fromHtml
                    |> Expect.all
                        (List.map
                            (\todo ->
                                Query.has
                                    [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "note-todo-text-input"
                                    , Test.Html.Selector.attribute <| Html.Attributes.attribute "value" <| todo.text
                                    ]
                            )
                            todos
                        )
        , test "it has a done checkbox for every todo" <|
            \_ ->
                let
                    title =
                        "title"

                    todos : List Todo
                    todos =
                        [ Todo "1" "1" True, Todo "2" "2" False ]
                in
                div
                    []
                    (totdoNoteForm
                        { title = title, todos = todos }
                    )
                    |> Query.fromHtml
                    |> Query.has
                        (List.map
                            (\todo ->
                                Test.Html.Selector.checked <| todo.done
                            )
                            todos
                        )
        ]
