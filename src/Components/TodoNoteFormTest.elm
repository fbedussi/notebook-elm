module Components.TodoNoteFormTest exposing (..)

import Components.TodoNoteForm exposing (totdoNoteForm)
import Expect
import Html exposing (div)
import Html.Attributes
import Model exposing (Id, Todo)
import Test exposing (describe, test)
import Test.Html.Query as Query
import Test.Html.Selector


type Msg
    = UpdateTitle String
    | UpdateTodoDone Id Bool
    | UpdateTodoText Id String


defaultProps =
    { title = ""
    , todos = []
    , updateTitleMsg = UpdateTitle
    , updateTodoDoneMsg = UpdateTodoDone
    , updateTodoTextMsg = UpdateTodoText
    }


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
                        { defaultProps | title = title }
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
                        { defaultProps | title = title, todos = todos }
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
                        { defaultProps | title = title, todos = todos }
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
