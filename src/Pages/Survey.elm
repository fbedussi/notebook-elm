module Pages.Survey exposing (Model, Msg, update, view, init)

import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, type_)


type alias Model =
    { likeElm : Bool
    }


type Msg
    = SetLike Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLike likeElm ->
            ( { model | likeElm = likeElm }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ label []
            [ input [ type_ "checkbox", checked model.likeElm ] []
            , text "Do you like Elm?"
            ]
        ]


init : Bool -> Model
init initialLikeElm =
    { likeElm = initialLikeElm
    }
