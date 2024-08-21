port module Styleguide.Dialog exposing (..)

import Html exposing (Html, article, button, footer, header, main_, p, text)
import Html.Attributes exposing (attribute, id)
import Html.Events exposing (onClick)


type alias Id =
    String


port openDialog : Id -> Cmd msg


port closeDialog : Id -> Cmd msg


port dialogClosed : (() -> msg) -> Sub msg


dialog : Id -> msg -> List (Html.Attribute msg) -> String -> ( List (Html msg), List (Html msg) ) -> Html msg
dialog elementId onCloseMsg attr title ( content, footerContent ) =
    Html.node "dialog"
        (id elementId :: attr)
        [ article []
            [ header []
                [ p [] [ text title ]
                , button [ attribute "aria-label" "Close", attribute "rel" "prev", onClick onCloseMsg ] []
                ]
            , main_ [] content
            , if List.length footerContent > 0 then
                footer [] footerContent

              else
                text ""
            ]
        ]
