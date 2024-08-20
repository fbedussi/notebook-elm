module Pages.List.NoteCard exposing (..)

import Html exposing (Html, a, article, footer, header, main_, text)
import Html.Attributes exposing (attribute, class, href)
import Model exposing (Note)
import Pages.List.Model exposing (Msg)
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
            [ a [ href ("./note/" ++ note.id), class "no-style", attribute "data-testid" "edit-btn" ] [ editIcon ] ]
        ]
