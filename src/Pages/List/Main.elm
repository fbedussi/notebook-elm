module Pages.List.Main exposing (init, subscriptions, update, view)

import Backend
import Browser.Events exposing (onKeyPress)
import Common.Model exposing (withCommonOp, withNoCommonOp)
import Decoders exposing (keyDecoder, notesDecoder)
import DnDList
import Html exposing (Html, button, main_, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Json.Decode
import Model exposing (DndData, NewNoteData(..), Todo, updateNewNoteText, updateNewNoteTitle, updateNewTodoDone, updateNewTodoText, updateTodoText)
import Pages.List.AddNoteForm exposing (addNoteForm)
import Pages.List.Model exposing (Model, Msg(..))
import Pages.List.NoteCard exposing (noteCard)
import Styleguide.Dialog exposing (closeDialog, dialog, dialogClosed, openDialog)
import Styleguide.ErrorAlert exposing (errorAlert)
import Styleguide.Icons.Plus exposing (plusIcon)
import Utils exposing (getCopyNotePayload, newestFirst)


dndConfig : DnDList.Config Todo
dndConfig =
    { beforeUpdate = \_ _ list -> list
    , movement = DnDList.Vertical
    , listen = DnDList.OnDrag
    , operation = DnDList.Swap
    }


dndSystem : DnDList.System Todo Msg
dndSystem =
    DnDList.create dndConfig SwapTodos


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
            ( { model | newNoteData = updateNewNoteTitle model.newNoteData newNoteTitle, newNoteFormPristine = False }, Cmd.none )
                |> withNoCommonOp

        UpdateNewNoteText newNoteText ->
            ( { model | newNoteData = updateNewNoteText model.newNoteData newNoteText, newNoteFormPristine = False }, Cmd.none )
                |> withNoCommonOp

        AddNote ->
            let
                ( updatedModel, closeFormCmd, commonMsg ) =
                    update CloseAddNoteForm model

                cleanNewNoteData =
                    NewTextNoteData { title = "", text = "" }
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

        SetNoteType newNoteData ->
            ( { model | newNoteData = newNoteData }, Cmd.none )
                |> withNoCommonOp

        UpdateTodoDone todoId done ->
            ( { model | newNoteData = updateNewTodoDone model.newNoteData todoId done }, Cmd.none )
                |> withNoCommonOp

        UpdateTodoText todoId text ->
            ( { model | newNoteData = updateNewTodoText model.newNoteData todoId text }, Cmd.none )
                |> withNoCommonOp

        CheckShortcuts char ->
            if char == '+' && model.addNoteFormOpen == False then
                update OpenAddNoteForm model

            else
                ( model, Cmd.none ) |> withNoCommonOp

        SwapTodos dndMsg ->
            case model.newNoteData of
                NewTextNoteData _ ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

                NewTodoNoteData { title, todos } ->
                    let
                        ( dnd, updatedTodos ) =
                            dndSystem.update dndMsg model.dnd todos
                    in
                    ( { model | dnd = dnd, newNoteData = NewTodoNoteData { title = title, todos = updatedTodos } }
                    , dndSystem.commands dnd
                    )
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
            (addNoteForm (DndData dndSystem model.dnd) model.newNoteData model.newNoteFormPristine)

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
            NewTextNoteData
                { title = ""
                , text = ""
                }
      , newNoteFormPristine = True
      , noteToDelete = Nothing
      , error = Nothing
      , dnd = dndSystem.model
      }
    , Backend.getNotes ()
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Backend.gotNotes decodeNotes
        , dialogClosed DialogClosed
        , onKeyPress (keyDecoder CheckShortcuts)
        , dndSystem.subscriptions model.dnd
        ]
