module Pages.List.NoteCard exposing (..)

import Html exposing (Html, a, article, div, footer, header, input, li, main_, span, text, ul)
import Html.Attributes exposing (attribute, checked, class, disabled, href, style, type_, value)
import Html.Events exposing (onClick)
import HtmlUtils exposing (testId)
import Model exposing (Note, NoteContent(..), Todo)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Copy exposing (copyIcon)
import Styleguide.Icons.Delete exposing (deleteIcon)
import Styleguide.Icons.Edit exposing (editIcon)


noteCard : Note -> Html Msg
noteCard note =
    let
        mainContent =
            case note.content of
                TextNoteContent data ->
                    [ text data.text ]

                TodoNoteContent data ->
                    todosView data.todos
    in
    article
        [ attribute "data-testid" "note", class "note-card" ]
        [ header
            []
            [ text note.title ]
        , main_
            []
            mainContent
        , footer
            []
            [ div
                [ style "display" "flex", style "gap" "1rem" ]
                [ button [ attribute "data-testid" "delete-note-btn", onClick (DeleteNote note), class "outline", class "secondary" ] [ deleteIcon ]
                , button [ attribute "data-testid" "copy-note-btn", onClick (CopyNote note), class "outline" ] [ copyIcon ]
                ]
            , a [ href ("./note/" ++ note.id), class "no-style", attribute "data-testid" "edit-btn", attribute "role" "button" ] [ editIcon ]
            ]
        ]


todosView : List Todo -> List (Html Msg)
todosView todos =
    [ ul
        []
        (todos
            |> List.filter (\todo -> todo.text /= "" && todo.id /= String.fromInt (List.length todos + 1))
            |> List.map todoView
        )
    ]


todoView : Todo -> Html Msg
todoView todo =
    li
        []
        [ input
            [ type_ "checkbox", checked todo.done, disabled True ]
            []
        , span
            [ testId "todo-text" ]
            [ text todo.text ]
        ]
