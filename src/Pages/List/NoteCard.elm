module Pages.List.NoteCard exposing (..)

import Html exposing (Html, a, article, footer, header, main_, text)
import Html.Attributes exposing (attribute, class, href)
import Html.Events exposing (onClick)
import Model exposing (Note)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Delete exposing (deleteIcon)
import Styleguide.Icons.Edit exposing (editIcon)


noteCard : Note -> Html Msg
noteCard note =
    article
        [ attribute "data-testid" "note", class "note-card" ]
        [ header
            []
            [ text note.title ]
        , main_
            []
            [ text note.text ]
        , footer
            []
            [ button [ attribute "data-testid" "delete-note-btn", onClick (DeleteNote note), class "outline", class "secondary" ] [ deleteIcon ]
            , a [ href ("./note/" ++ note.id), class "no-style", attribute "data-testid" "edit-btn", attribute "role" "button" ] [ editIcon ]
            ]
        ]
