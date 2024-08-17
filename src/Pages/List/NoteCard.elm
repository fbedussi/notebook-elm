module Pages.List.NoteCard exposing (..)

import Html exposing (Html, article, header, main_, text)
import Html.Attributes exposing (attribute)
import Model exposing (Note)
import Pages.List.Model exposing (Msg)


noteCard : Note -> Html Msg
noteCard note =
    article
        [ attribute "data-testid" "note" ]
        [ header
            []
            [ text note.title ]
        , main_
            []
            [ text note.text ]
        ]
