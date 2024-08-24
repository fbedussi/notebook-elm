module Pages.Login.Main exposing (..)

import Backend
import Encoders exposing (loginDataEncoder)
import Html exposing (form, header, main_, text)
import Html.Attributes exposing (attribute, class, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Pages.Login.Model exposing (Model, Msg(..))
import Styleguide.Button exposing (button)
import Styleguide.Icons.Login exposing (loginIcon)
import Styleguide.TextBox exposing (textBox)


update msg model =
    case msg of
        UpdateUsername username ->
            ( { model | username = username }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        Login ->
            ( model, Backend.login (loginDataEncoder model) )


view model =
    [ main_ [ class "container" ]
        [ form
            [ onSubmit Login ]
            [ textBox { labelAttributes = [ attribute "data-testid" "username-input", onInput UpdateUsername ], inputAttributes = [ value model.username ] } "Username"
            , textBox { labelAttributes = [ attribute "data-testid" "password-input", onInput UpdatePassword ], inputAttributes = [ value model.password, type_ "password" ] } "Password"
            , button [ type_ "submit", attribute "data-testid" "login-btn" ] [ loginIcon ]
            ]
        ]
    ]


init : Model
init =
    Model "" ""
