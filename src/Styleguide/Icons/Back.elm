module Styleguide.Icons.Back exposing (..)

import Html.Attributes exposing (attribute)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, viewBox)
import Svg.Attributes exposing (fill)


backIcon =
    svg
        [ viewBox "0 0 24 24", attribute "data-testid" "ArrowBackIcon", fill "currentColor" ]
        [ path
            [ d "M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20z" ]
            []
        ]
