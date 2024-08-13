port module Pages.Counter exposing (Model, Msg, init, update, view)

import Html exposing (Html, button, div, span, text)
import Html.Attributes exposing (attribute)
import Html.Events exposing (onClick)


type alias Model =
    { counter : Int
    }


type Msg
    = Increment
    | Decrement


port setCounter : Int -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            let
                counter =
                    model.counter + 1
            in
            ( { model | counter = counter }, setCounter counter )

        Decrement ->
            let
                counter =
                    model.counter - 1
            in
            ( { model | counter = counter }, setCounter counter )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ]
            [ text "-" ]
        , span
            [ attribute "data-testid" "counter-display" ]
            [ text (String.fromInt model.counter) ]
        , button
            [ onClick Increment ]
            [ text "+" ]
        ]


init : Int -> { counter : Int }
init initialCounter =
    { counter = initialCounter
    }
