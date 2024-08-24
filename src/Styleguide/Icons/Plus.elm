module Styleguide.Icons.Plus exposing (..)

import Html.Attributes exposing (attribute)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, viewBox)
import Svg.Attributes exposing (fill)


plusIcon =
    svg
        [ viewBox "0 0 24 24", attribute "data-testid" "AddIcon", fill "currentColor" ]
        [ path [ d "M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6z" ] []
        ]
