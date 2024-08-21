module Pages.List.DelNoteConfirmation exposing (..)

import Html exposing (text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Pages.List.Model exposing (Msg(..))
import Styleguide.Button exposing (button)


delNoteConfirmation note =
    ( [ text ("Are you sure to delete note \"" ++ note.title ++ "\"?") ]
    , [ button
            [ onClick CloseDelNoteForm
            ]
            [ text "no, keep it" ]
      , button
            [ onClick (DelNote note.id), class "outline", class "secondary", attribute "data-testid" "ok-btn" ]
            [ text "yes, delete delete it" ]
      ]
    )
