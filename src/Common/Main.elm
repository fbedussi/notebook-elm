module Common.Main exposing (..)

import Backend
import Common.DelNoteConfirmation exposing (delNoteConfirmation)
import Common.Model exposing (Model, Msg(..))
import Html exposing (Html, text)
import Html.Attributes exposing (attribute)
import Styleguide.Dialog exposing (closeDialog, dialog, openDialog)


init : Model
init =
    { noteToDelete = Nothing
    }


delNoteDialogId : String
delNoteDialogId =
    "del-note-dialog"


update : (() -> Cmd Msg) -> Msg -> Model -> ( Model, Cmd Msg )
update redirectToListPage msg model =
    case msg of
        OpenDelNoteForm noteToDelete ->
            ( { model | noteToDelete = Just noteToDelete }, openDialog delNoteDialogId )

        DelNote noteId ->
            let
                ( updatedModel, closeCmd ) =
                    update redirectToListPage CloseDelNoteForm model
            in
            ( updatedModel, Cmd.batch [ Backend.delNote noteId, redirectToListPage (), closeCmd ] )

        CloseDelNoteForm ->
            ( model, closeDialog delNoteDialogId )

        DialogClosed () ->
            ( { model | noteToDelete = Nothing }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


view : Model -> List (Html Msg)
view model =
    [ case model.noteToDelete of
        Just note ->
            dialog
                delNoteDialogId
                CloseDelNoteForm
                [ attribute "data-testid" "delete-note-confirmation" ]
                "Delete note"
                (delNoteConfirmation note)

        Nothing ->
            text ""
    ]
