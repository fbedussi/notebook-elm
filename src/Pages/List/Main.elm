module Pages.List.Main exposing (init, subscriptions, update, view)

import Backend
import Common.Model exposing (withCommonOp, withNoCommonOp)
import Decoders exposing (notesDecoder)
import Html exposing (Html, button, header, main_, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Json.Decode
import Pages.List.AddNoteForm exposing (addNoteForm)
import Pages.List.Model exposing (Model, Msg(..))
import Pages.List.NoteCard exposing (noteCard)
import Styleguide.Dialog exposing (closeDialog, dialog, dialogClosed, openDialog)
import Styleguide.ErrorAlert exposing (errorAlert)
import Styleguide.Icons.Plus exposing (plusIcon)
import Utils exposing (getCopyNotePayload, newestFirst)


addNoteDialogId : String
addNoteDialogId =
    "add-note-dialog"


update : Msg -> Model -> ( Model, Cmd Msg, Common.Model.Msg )
update msg model =
    case msg of
        OpenAddNoteForm ->
            ( { model | addNoteFormOpen = True }, openDialog addNoteDialogId )
                |> withNoCommonOp

        CloseAddNoteForm ->
            ( model, closeDialog addNoteDialogId )
                |> withNoCommonOp

        DialogClosed () ->
            ( { model | addNoteFormOpen = False }, Cmd.none )
                |> withNoCommonOp

        DeleteNote note ->
            ( model, Cmd.none )
                |> withCommonOp (Common.Model.OpenDelNoteForm note)

        UpdateNewNoteTitle newNoteTitle ->
            let
                prevNewNodeData =
                    model.newNoteData

                updatedNewNodeData =
                    { prevNewNodeData | title = newNoteTitle }
            in
            ( { model | newNoteData = updatedNewNodeData }, Cmd.none )
                |> withNoCommonOp

        UpdateNewNoteText newNoteText ->
            let
                prevNewNodeData =
                    model.newNoteData

                updatedNewNodeData =
                    { prevNewNodeData | text = newNoteText }
            in
            ( { model | newNoteData = updatedNewNodeData }, Cmd.none )
                |> withNoCommonOp

        AddNote ->
            let
                ( updatedModel, closeFormCmd, commonMsg ) =
                    update CloseAddNoteForm model

                cleanNewNoteData =
                    { title = "", text = "" }
            in
            ( { updatedModel | newNoteData = cleanNewNoteData }, Cmd.batch [ closeFormCmd, model.newNoteData |> Backend.addNewNote ], commonMsg )

        GotError message ->
            ( { model | error = Just message }, Cmd.none )
                |> withNoCommonOp

        GotNotes notes ->
            ( { model | notes = notes }, Cmd.none )
                |> withNoCommonOp

        CopyNote note ->
            ( model, getCopyNotePayload note |> Backend.addNewNote )
                |> withNoCommonOp


decodeNotes : Json.Decode.Value -> Msg
decodeNotes value =
    let
        decodedValue =
            Json.Decode.decodeValue notesDecoder value
    in
    case decodedValue of
        Ok notes ->
            GotNotes notes

        Err error ->
            GotError ("Error decoding notes: " ++ Json.Decode.errorToString error)


view : Model -> List (Html Msg)
view model =
    [ if model.addNoteFormOpen then
        dialog
            addNoteDialogId
            CloseAddNoteForm
            []
            "Add note"
            (addNoteForm model.newNoteData)

      else
        text ""
    , main_ [ class "container" ] (model.notes |> List.sortWith newestFirst |> List.map noteCard)
    , errorAlert model.error
    , button [ attribute "data-testid" "add-note-btn", class "add-note-btn", class "fab", onClick OpenAddNoteForm ] [ plusIcon ]
    ]


init : () -> ( Model, Cmd Msg )
init () =
    ( { notes = []
      , addNoteFormOpen = False
      , newNoteData =
            { title = ""
            , text = ""
            }
      , noteToDelete = Nothing
      , error = Nothing
      }
    , Backend.getNotes ()
    )


subscriptions : () -> Sub Msg
subscriptions () =
    Sub.batch
        [ Backend.gotNotes decodeNotes
        , dialogClosed DialogClosed
        ]
