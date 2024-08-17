module Styleguide.TextArea exposing (..)

import Html exposing (label, span, text, textarea)


type alias LabelText =
    String


textArea : { labelAttributes : List (Html.Attribute msg), inputAttributes : List (Html.Attribute msg) } -> LabelText -> Html.Html msg
textArea { labelAttributes, inputAttributes } labelText =
    label labelAttributes
        [ span [] [ text labelText ]
        , textarea inputAttributes []
        ]
