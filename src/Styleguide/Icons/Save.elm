module Styleguide.Icons.Save exposing (..)

import Html.Attributes exposing (attribute)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, fill, viewBox)


saveIcon =
    svg
        [ viewBox "0 0 24 24", attribute "data-testid" "SaveIcon", fill "currentColor" ]
        [ path
            [ d "M17 3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V7zm-5 16c-1.66 0-3-1.34-3-3s1.34-3 3-3 3 1.34 3 3-1.34 3-3 3m3-10H5V5h10z" ]
            []
        ]
