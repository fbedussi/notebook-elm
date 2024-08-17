port module Styleguide.Dialog exposing (..)

import Html exposing (Html, article, button, div, h1, header, main_, p, text)
import Html.Attributes exposing (attribute, class, id, style)
import Html.Events exposing (onClick)


type alias Id =
    String


port openDialog : Id -> Cmd msg


port closeDialog : Id -> Cmd msg


dialog : Id -> msg -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
dialog elementId onCloseMsg attr content =
    Html.node "dialog"
        (id elementId :: attr)
        [ article []
            [ header []
                [ p [] [ text "" ]
                , button [ attribute "aria-label" "Close", attribute "rel" "prev", onClick onCloseMsg ] []
                ]
            , main_ [] content
            ]
        ]
