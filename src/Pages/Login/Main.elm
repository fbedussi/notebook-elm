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


update : Pages.Login.Model.Msg -> Pages.Login.Model.Model -> ( Pages.Login.Model.Model, Cmd Msg )
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
            [ textBox
                { labelAttributes =
                    [ attribute "autocomplete" "username"
                    , onInput UpdateUsername
                    ]
                , inputAttributes =
                    [ value model.username
                    , attribute "data-testid" "username-input"
                    ]
                }
                "Username"
            , textBox
                { labelAttributes =
                    [ attribute "data-testid" "password-input"
                    , onInput UpdatePassword
                    ]
                , inputAttributes =
                    [ attribute "autocomplete" "current-password"
                    , value model.password
                    , type_ "password"
                    ]
                }
                "Password"
            , button [ type_ "submit", attribute "data-testid" "login-btn" ] [ loginIcon ]
            ]
        ]
    ]


init : Model
init =
    Model "" ""
