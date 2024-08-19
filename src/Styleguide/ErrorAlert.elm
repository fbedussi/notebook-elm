module Styleguide.ErrorAlert exposing (..)
import Html exposing (Html)
import Html exposing (div)
import Html.Attributes exposing (class)
import Html exposing (text)
import Html.Attributes exposing (hidden)

errorAlert : Maybe String -> Html msg
errorAlert maybeError =
    case maybeError of
        Just errorMessage ->
            div [ class "error" ] [ text errorMessage ]

        Nothing ->
            div [ hidden True ] []
