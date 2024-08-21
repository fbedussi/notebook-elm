module Pages.Single.Main exposing (init, subscriptions, update, view)

import Backend exposing (getNote, gotNote)
import Constants exposing (..)
import Decoders exposing (noteDecoder)
import Html exposing (Html, a, header, main_)
import Html.Attributes exposing (attribute, class, href)
import Json.Decode
import Json.Encode
import Model exposing (Id, Note)
import Pages.Single.EditNoteForm exposing (editNoteForm)
import Pages.Single.Model exposing (Model, Msg(..))
import Styleguide.ErrorAlert exposing (errorAlert)
import Styleguide.Icons.Back exposing (backIcon)
import Time exposing (posixToMillis)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotNote note ->
            ( { model | note = Just note }, Cmd.none )

        GotError errorMsg ->
            ( { model | error = Just errorMsg }, Cmd.none )

        SaveNote ->
            case model.note of
                Just note ->
                    ( { model | isFormDirty = False }, Backend.saveNote (noteEncoder note) )

                Nothing ->
                    ( model, Cmd.none )

        UpdateNewNoteTitle newNoteTitle ->
            case model.note of
                Just prevNoteData ->
                    let
                        updatedNoteData =
                            { prevNoteData | title = newNoteTitle }
                    in
                    ( { model | note = Just updatedNoteData, isFormDirty = True }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        UpdateNewNoteText newNoteText ->
            case model.note of
                Just prevNoteData ->
                    let
                        updatedNoteData =
                            { prevNoteData | text = newNoteText }
                    in
                    ( { model | note = Just updatedNoteData, isFormDirty = True }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )


noteEncoder : Note -> Json.Encode.Value
noteEncoder note =
    Json.Encode.object
        [ ( "id", Json.Encode.string note.id )
        , ( "title", Json.Encode.string note.title )
        , ( "text", Json.Encode.string note.text )
        , ( "createdAt", Json.Encode.int (posixToMillis note.createdAt) )
        , ( "updatedAt", Json.Encode.int (posixToMillis note.updatedAt) )
        , ( "version", Json.Encode.int note.version )
        ]


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
