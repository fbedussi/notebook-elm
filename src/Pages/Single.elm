module Pages.Single exposing (Model, Msg, init, update, view)

import Html exposing (Html, div)
import Model exposing (Id, Note)


type alias Model =
    { id : String
    , note : Maybe Note
    }


type Msg
    = SaveNote Note


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SaveNote _ ->
            ( model, Cmd.none )


view : Model -> List (Html Msg)
view _ =
    [ div []
        []
    ]


init : Id -> Model
init id =
    { id = id
    , note = Nothing
    }
