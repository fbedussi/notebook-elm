module Main exposing (getTitle, main)

import Browser
import Browser.Navigation as Nav
import Constants exposing (..)
import Html exposing (..)
import Model exposing (Note)
import Pages.List.Main as ListPage
import Pages.List.Model
import Pages.Single.Main as SinglePage
import Pages.Single.Model
import Router exposing (Route(..), parseUrl, performUrlChange, sendUrlChangeRequest)
import Url exposing (Url)
import Url.Parser exposing ((</>))
import Backend

type alias Model =
    { navigation :
        { key : Nav.Key
        , route : Route
        , basePath : String
        }
    , listPage : Pages.List.Model.Model
    , singlePage : Pages.Single.Model.Model
    }


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model.navigation.route of
                ListRoute ->
                    ListPage.view model.listPage
                        |> List.map (Html.map GotListMsg)

                SingleRoute id ->
                    let
                        singleModel =
                            model.singlePage
                    in
                    SinglePage.view { singleModel | id = id }
                        |> List.map (Html.map GotSingleMsg)

                NotFoundRoute ->
                    [ text "Sorry, I did't find this page" ]
    in
    { title =
        getTitle model.navigation.route model.singlePage.note
    , body =
        content
    }


getTitle : Route -> Maybe Note -> String
getTitle route maybeNote =
    let
        noteTitle =
            case maybeNote of
                Just note ->
                    note.title

                Nothing ->
                    ""
    in
    case route of
        SingleRoute _ ->
            "Notebook - " ++ noteTitle

        _ ->
            "Notebook"


type Msg
    = ClickedLink Browser.UrlRequest
    | PerformUrlChange String
    | ChangedUrl Url
    | GotListMsg Pages.List.Model.Msg
    | GotSingleMsg Pages.Single.Model.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink (Browser.Internal url) ->
            ( model, Url.toString url |> sendUrlChangeRequest )

        ClickedLink (Browser.External string) ->
            ( model, Nav.load string )

        PerformUrlChange urlString ->
            ( model, Nav.pushUrl model.navigation.key urlString )

        ChangedUrl url ->
            let
                route =
                    parseUrl model.navigation.basePath url

                cmd =
                    case route of
                        SingleRoute id ->
                            Backend.getNote id

                        ListRoute ->
                            Backend.getNotes ()

                        NotFoundRoute ->
                            Cmd.none

                navigation =
                    model.navigation
            in
            ( { model | navigation = { navigation | route = route } }
            , cmd
            )

        GotListMsg listMsg ->
            case model.navigation.route of
                ListRoute ->
                    let
                        ( listMode, listCmd ) =
                            ListPage.update listMsg model.listPage
                    in
                    ( { model | listPage = listMode }, Cmd.map GotListMsg listCmd )

                _ ->
                    ( model, Cmd.none )

        GotSingleMsg singleMsg ->
            case model.navigation.route of
                SingleRoute id ->
                    let
                        oldSingleModel =
                            model.singlePage

                        ( singleModel, singleCmd ) =
                            SinglePage.update singleMsg { oldSingleModel | id = id }
                    in
                    ( { model | singlePage = singleModel }, Cmd.map GotSingleMsg singleCmd )

                _ ->
                    ( model, Cmd.none )


type alias Flags =
    { basePath : String }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init { basePath } url navigationKey =
    let
        route =
            parseUrl basePath url

        selectedNoteId =
            case route of
                SingleRoute id ->
                    id

                _ ->
                    ""

        ( listPageModel, listPageCmd ) =
            ListPage.init ()

        ( singlePageModel, singlePageCmd ) =
            SinglePage.init selectedNoteId
    in
    ( { navigation =
            { key = navigationKey
            , route = route
            , basePath = basePath
            }
      , listPage = listPageModel
      , singlePage = singlePageModel
      }
    , Cmd.batch [ singlePageCmd |> Cmd.map GotSingleMsg, listPageCmd |> Cmd.map GotListMsg ]
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ performUrlChange PerformUrlChange
        , ListPage.subscriptions ()
            |> Sub.map GotListMsg
        , SinglePage.subscriptions ()
            |> Sub.map GotSingleMsg
        ]
