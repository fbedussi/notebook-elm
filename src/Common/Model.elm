module Common.Model exposing (..)

import Model exposing (Id, Note)


type Msg
    = OpenDelNoteForm Note
    | DelNote Id
    | CloseDelNoteForm
    | NoOp


type alias Model =
    { noteToDelete : Maybe Note
    , showBackButton : Bool
    }


withNoCommonOp : ( a, b ) -> ( a, b, Msg )
withNoCommonOp ( a, b ) =
    ( a, b, NoOp )


withCommonOp : Msg -> ( a, b ) -> ( a, b, Msg )
withCommonOp msg ( a, b ) =
    ( a, b, msg )
