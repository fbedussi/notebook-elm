port module Pages.Survey exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (Html, div, input, label, text)
import Html.Attributes exposing (checked, type_)
import Html.Events exposing (onClick)


type alias Model =
    { likeElm : Bool
    , name : String
    }


type Msg
    = SetLike Bool
    | GotUserName String


port getUserName : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    getUserName GotUserName


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetLike likeElm ->
            ( { model | likeElm = likeElm }, Cmd.none )

        GotUserName userName ->
            ( { model | name = Debug.log "userName" userName }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text ("Hi, " ++ model.name) ]
        , label []
            [ input [ type_ "checkbox", checked model.likeElm, not model.likeElm |> SetLike |> onClick ] []
            , text "Do you like Elm?"
            ]
        ]


init : Bool -> String -> Model
init initialLikeElm name =
    { likeElm = initialLikeElm
    , name = name
    }
