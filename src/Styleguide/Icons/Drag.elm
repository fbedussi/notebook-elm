module Styleguide.Icons.Drag exposing (..)

import Html.Attributes exposing (attribute, title)
import HtmlUtils exposing (testId)
import Svg exposing (path, svg)
import Svg.Attributes exposing (d, fill, viewBox)


dragIcon =
    svg
        [ viewBox "0 0 24 24", testId "drag-icon", title "drag indicator", fill "currentColor" ]
        [ path
            [ d "M11 18c0 1.1-.9 2-2 2s-2-.9-2-2 .9-2 2-2 2 .9 2 2m-2-8c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2m0-6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2m6 4c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2m0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2m0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2" ]
            []
        ]
