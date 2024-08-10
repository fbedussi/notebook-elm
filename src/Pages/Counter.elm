module Pages.Counter exposing (Model, Msg, init, update, view)

import Html exposing (Html, button, div, span, text)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    }


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ]
            [ text "-" ]
        , span
            []
            [ text (String.fromInt model.counter) ]
        , button
            [ onClick Increment ]
            [ text "+" ]
        ]


init : Int -> { counter : Int }
init initialCounter =
    { counter = initialCounter
    }
