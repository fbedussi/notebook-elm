module Common.DelNoteConfirmation exposing (..)

import Common.Model exposing (Msg(..))
import Html exposing (text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Styleguide.Button exposing (button)


delNoteConfirmation note =
    ( [ text ("Are you sure to delete note \"" ++ note.title ++ "\"?") ]
    , [ button
            [ onClick CloseDelNoteForm, attribute "data-testid" "cancel-btn"
            ]
            [ text "no, keep it" ]
      , button
            [ onClick (DelNote note.id), class "outline", class "secondary", attribute "data-testid" "ok-btn" ]
            [ text "yes, delete delete it" ]
      ]
    )
