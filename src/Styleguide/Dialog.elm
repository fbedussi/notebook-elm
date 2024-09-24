module Styleguide.Dialog exposing (..)

import Html exposing (Html, article, button, footer, header, main_, p, text)
import Html.Attributes exposing (attribute, id)
import Html.Events exposing (onClick)


dialog : msg -> List (Html.Attribute msg) -> String -> ( List (Html msg), List (Html msg) ) -> Bool -> Html msg
dialog onCloseMsg attr title ( content, footerContent ) open =
    Html.node "my-modal"
        (getOpenAttribute open
            :: attr
        )
        [ Html.node "dialog"
            []
            [ article
                []
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
        ]


getOpenAttribute open =
    (if open then
        "true"

     else
        "false"
    )
        |> Html.Attributes.attribute "open"
