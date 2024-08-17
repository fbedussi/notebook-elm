module Styleguide.TextBox exposing (..)

import Html exposing (input, label, span, text)
import Html.Attributes exposing (type_)


type alias LabelText =
    String


textBox : { labelAttributes : List (Html.Attribute msg), inputAttributes : List (Html.Attribute msg) } -> LabelText -> Html.Html msg
textBox { labelAttributes, inputAttributes } labelText =
    label labelAttributes
        [ span [] [ text labelText ]
        , input (type_ "text" :: inputAttributes) []
        ]
