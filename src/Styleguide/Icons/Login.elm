module Styleguide.Icons.Login exposing (..)

import Html.Attributes exposing (attribute)
import Svg exposing (Svg, path, svg)
import Svg.Attributes exposing (d, fill, viewBox)


loginIcon =
    svg
        [ viewBox "0 0 24 24", attribute "data-testid" "LoginIcon", fill "currentColor" ]
        [ path
            [ d "M11 7 9.6 8.4l2.6 2.6H2v2h10.2l-2.6 2.6L11 17l5-5zm9 12h-8v2h8c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2h-8v2h8z" ]
            []
        ]
