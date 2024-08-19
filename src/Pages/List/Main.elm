port module Pages.List.Main exposing (getNotes, init, subscriptions, update, view)

import Decoders exposing (notesDecoder)
import Html exposing (Html, button, header, main_, text)
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)
import Json.Decode
import Json.Encode
import Model exposing (Note)
import Pages.List.AddNoteForm exposing (addNoteForm)
import Pages.List.Model exposing (Model, Msg(..), NewNoteData)
import Pages.List.NoteCard exposing (noteCard)
import Styleguide.Dialog exposing (closeDialog, dialog, openDialog)
import Styleguide.ErrorAlert exposing (errorAlert)
import Styleguide.Icons.Plus exposing (plusIcon)
import Time exposing (posixToMillis)


port addNote : String -> Cmd msg


port getNotes : () -> Cmd msg


port gotNotes : (Json.Decode.Value -> msg) -> Sub msg


addNoteDialogId : String
addNoteDialogId =
    "add-note-dialog"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenAddNoteForm ->
            ( { model | addNoteFormOpen = True }, openDialog addNoteDialogId )

        CloseAddNoteForm ->
            ( { model | addNoteFormOpen = False }, closeDialog addNoteDialogId )

        UpdateNewNoteTitle newNoteTitle ->
            let
                prevNewNodeData =
                    model.newNoteData

                updatedNewNodeData =
                    { prevNewNodeData | title = newNoteTitle }
            in
            ( { model | newNoteData = updatedNewNodeData }, Cmd.none )

        UpdateNewNoteText newNoteText ->
            let
                prevNewNodeData =
                    model.newNoteData

                updatedNewNodeData =
                    { prevNewNodeData | text = newNoteText }
            in
            ( { model | newNoteData = updatedNewNodeData }, Cmd.none )

        AddNote ->
            let
                ( updatedModel, closeFormCmd ) =
                    update CloseAddNoteForm model

                cleanNewNoteData =
                    { title = "", text = "" }
            in
            ( { updatedModel | newNoteData = cleanNewNoteData }, Cmd.batch [ closeFormCmd, newNoteDataEncoder model.newNoteData |> Json.Encode.encode 0 |> addNote ] )

        GotError message ->
            ( { model | error = Just message }, Cmd.none )

        GotNotes notes ->
            ( { model | notes = notes }, Cmd.none )


newNoteDataEncoder : NewNoteData -> Json.Encode.Value
newNoteDataEncoder newNoteData =
    Json.Encode.object
        [ ( "title", Json.Encode.string newNoteData.title )
        , ( "text", Json.Encode.string newNoteData.text )
        ]


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
    [ dialog
        addNoteDialogId
        CloseAddNoteForm
        []
        [ addNoteForm model.newNoteData ]
    , header [] [ text "Notebook" ]
    , main_ [ class "container" ] (model.notes |> List.sortWith newestFirst |> List.map noteCard)
    , errorAlert model.error
    , button [ attribute "data-testid" "add-note-btn", class "add-note-btn", class "fab", onClick OpenAddNoteForm ] [ plusIcon ]
    ]


newestFirst : Note -> Note -> Order
newestFirst noteA noteB =
    let
        updatedAtA =
            posixToMillis noteA.updatedAt

        updatedAtB =
            posixToMillis noteB.updatedAt
    in
    case compare updatedAtA updatedAtB of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


init : () -> ( Model, Cmd Msg )
init () =
    ( { notes = []
      , addNoteFormOpen = False
      , newNoteData =
            { title = ""
            , text = ""
            }
      , error = Nothing
      }
    , getNotes ()
    )


subscriptions : () -> Sub Msg
subscriptions () =
    gotNotes decodeNotes
