module Pages.Single.Main exposing (dndSystem, init, subscriptions, update, view)

import Backend exposing (getNote, gotNote)
import Common.Model exposing (withCommonOp, withNoCommonOp)
import Constants exposing (..)
import Decoders exposing (noteDecoder)
import DnDList
import Encoders exposing (noteEncoder)
import Html exposing (Html, main_)
import Html.Attributes exposing (class)
import Json.Decode
import Model exposing (DndData, Id, NoteContent(..), TextNoteContentData, Todo, TodoNoteContentData, updateNoteText, updateTodoDone, updateTodoText)
import Pages.Single.EditNoteForm exposing (editNoteForm)
import Pages.Single.Model exposing (Model, Msg(..))
import Styleguide.ErrorAlert exposing (errorAlert)
import Utils exposing (getCopyNotePayload)


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


update : (Id -> Cmd Msg) -> Msg -> Model -> ( Model, Cmd Msg, Common.Model.Msg )
update redirectToSinglePage msg model =
    case msg of
        GotNote note ->
            if model.isCopyingNote then
                ( { model | isCopyingNote = False }, redirectToSinglePage note.id )
                    |> withNoCommonOp

            else
                ( { model | note = Just note }, Cmd.none )
                    |> withNoCommonOp

        GotError errorMsg ->
            ( { model | error = Just errorMsg }, Cmd.none )
                |> withNoCommonOp

        SaveNote ->
            case model.note of
                Just note ->
                    ( { model | isFormDirty = False }, Backend.saveNote (noteEncoder note) )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        UpdateNoteTitle noteTitle ->
            case model.note of
                Just prevNoteData ->
                    let
                        updatedNoteData =
                            { prevNoteData | title = noteTitle }
                    in
                    ( { model | note = Just updatedNoteData, isFormDirty = True }, Cmd.none )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        UpdateNoteText noteText ->
            case model.note of
                Just prevNoteData ->
                    ( { model | note = Just (updateNoteText prevNoteData noteText), isFormDirty = True }, Cmd.none )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        DeleteNote note ->
            ( model, Cmd.none )
                |> withCommonOp (Common.Model.OpenDelNoteForm note)

        CopyNote note ->
            ( { model | isCopyingNote = True }, getCopyNotePayload note |> Backend.addNewNote )
                |> withNoCommonOp

        UpdateTodoDone todoId done ->
            case model.note of
                Just prevNoteData ->
                    ( { model | note = Just (updateTodoDone prevNoteData todoId done), isFormDirty = True }, Cmd.none )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        UpdateTodoText todoId text ->
            case model.note of
                Just prevNoteData ->
                    ( { model | note = Just (updateTodoText prevNoteData todoId text), isFormDirty = True }, Cmd.none )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        SwapTodos dndMsg ->
            case model.note of
                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

                Just note ->
                    case note.content of
                        TextNoteContent _ ->
                            ( model, Cmd.none )
                                |> withNoCommonOp

                        TodoNoteContent { todos } ->
                            let
                                ( dnd, updatedTodos ) =
                                    dndSystem.update dndMsg model.dnd todos
                            in
                            ( { model | dnd = dnd, note = Just { note | content = TodoNoteContent { todos = updatedTodos } } }
                            , dndSystem.commands dnd
                            )
                                |> withNoCommonOp


view : Model -> List (Html Msg)
view model =
    [ main_ [ class "container" ] [ editNoteForm (DndData dndSystem model.dnd) model.isFormDirty model.note ]
    , errorAlert model.error
    ]


init : Id -> ( Model, Cmd Msg )
init id =
    ( { id = id
      , note = Nothing
      , error = Nothing
      , isFormDirty = False
      , isCopyingNote = False
      , dnd = dndSystem.model
      }
    , if id == "" then
        Cmd.none

      else
        getNote id
    )


decodeNote : Json.Decode.Value -> Msg
decodeNote value =
    let
        decodedValue =
            Json.Decode.decodeValue noteDecoder value
    in
    case decodedValue of
        Ok note ->
            GotNote note

        Err error ->
            GotError ("Error decoding notes: " ++ Json.Decode.errorToString error)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ gotNote decodeNote, dndSystem.subscriptions model.dnd ]
