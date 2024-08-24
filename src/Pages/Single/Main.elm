module Pages.Single.Main exposing (init, subscriptions, update, view)

import Backend exposing (getNote, gotNote)
import Common.Model exposing (withCommonOp, withNoCommonOp)
import Constants exposing (..)
import Decoders exposing (noteDecoder)
import Encoders exposing (noteEncoder)
import Html exposing (Html, a, header, main_)
import Html.Attributes exposing (attribute, class, href)
import Json.Decode
import Model exposing (Id)
import Pages.Single.EditNoteForm exposing (editNoteForm)
import Pages.Single.Model exposing (Model, Msg(..))
import Styleguide.ErrorAlert exposing (errorAlert)
import Styleguide.Icons.Back exposing (backIcon)
import Utils exposing (getCopyNotePayload)


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

        UpdateNewNoteTitle newNoteTitle ->
            case model.note of
                Just prevNoteData ->
                    let
                        updatedNoteData =
                            { prevNoteData | title = newNoteTitle }
                    in
                    ( { model | note = Just updatedNoteData, isFormDirty = True }, Cmd.none )
                        |> withNoCommonOp

                Nothing ->
                    ( model, Cmd.none )
                        |> withNoCommonOp

        UpdateNewNoteText newNoteText ->
            case model.note of
                Just prevNoteData ->
                    let
                        updatedNoteData =
                            { prevNoteData | text = newNoteText }
                    in
                    ( { model | note = Just updatedNoteData, isFormDirty = True }, Cmd.none )
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


view : Model -> List (Html Msg)
view model =
    [ header []
        [ a [ href "./", attribute "data-testid" "back-btn", class "no-style" ] [ backIcon ]
        ]
    , main_ [ class "container" ] [ editNoteForm model.isFormDirty model.note ]
    , errorAlert model.error
    ]


init : Id -> ( Model, Cmd Msg )
init id =
    ( { id = id
      , note = Nothing
      , error = Nothing
      , isFormDirty = False
      , isCopyingNote = False
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


subscriptions : () -> Sub Msg
subscriptions () =
    gotNote decodeNote
