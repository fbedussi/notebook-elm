module HtmlUtils exposing (..)

import Html.Attributes exposing (attribute)


testId id =
    attribute "data-testid" id
