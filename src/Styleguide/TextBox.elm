module Styleguide.TextBox exposing (..)

import Html exposing (input, label, text)
import Html.Attributes exposing (type_)
import Html.Attributes exposing (style)
import Html exposing (div)
import Html exposing (Html)


type alias LabelText =
    String

type alias Optionals msg =
    { endElement : Html msg
    }

defaults: Optionals msg 
defaults = 
    {endElement = text ""}

textBox : { labelAttributes : List (Html.Attribute msg), inputAttributes : List (Html.Attribute msg) } -> LabelText -> (Optionals msg -> Optionals msg) -> Html msg
textBox { labelAttributes, inputAttributes } labelText optionals=
    let
        {endElement} = optionals defaults
    in
    
    label labelAttributes
        [ div [style "position" "relative"] [ text labelText ]
        , div 
            [style "display" "flex", style "align-items" "center"]
            [ input (type_ "text" :: inputAttributes) []
            , endElement
            ]
        ]
