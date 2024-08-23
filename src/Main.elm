module Main exposing (getTitle, main, view)

import Backend
import Browser
import Browser.Navigation as Nav
import Common.Main
import Common.Model
import Constants exposing (..)
import Html exposing (..)
import Model exposing (Note)
import Pages.List.Main as ListPage
import Pages.List.Model exposing (Msg(..))
import Pages.Single.Main as SinglePage
import Pages.Single.Model
import Router exposing (Route(..), parseUrl, performUrlChange, sendUrlChangeRequest)
import Url exposing (Url)
import Url.Parser exposing ((</>))
import Utils exposing (newestFirst)


type alias Navigation =
    { key : Nav.Key
    , route : Route
    , basePath : String
    }


type alias Model =
    { navigation : Navigation
    , listPage : Pages.List.Model.Model
    , singlePage : Pages.Single.Model.Model
    , common : Common.Model.Model
    }


view : Model -> Browser.Document Msg
view model =
    let
        commonContent =
            Common.Main.view model.common
                |> List.map (Html.map GotCommonMsg)

        pageContent =
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

        content =
            commonContent ++ pageContent
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
    | GotCommonMsg Common.Model.Msg


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
                        ( listModel, listCmd, commonMsg ) =
                            ListPage.update listMsg model.listPage
                    in
                    ( { model | listPage = listModel }, Cmd.map GotListMsg listCmd )
                        |> withCommon commonMsg

                _ ->
                    ( model, Cmd.none )

        GotSingleMsg singleMsg ->
            case model.navigation.route of
                SingleRoute id ->
                    let
                        oldSingleModel =
                            model.singlePage

                        ( singleModel, singleCmd, commonMsg ) =
                            SinglePage.update singleMsg { oldSingleModel | id = id }
                    in
                    ( { model | singlePage = singleModel }, Cmd.map GotSingleMsg singleCmd )
                        |> withCommon commonMsg

                _ ->
                    ( model, Cmd.none )

        GotCommonMsg commonMsg ->
            let
                ( commonModel, commonCmd ) =
                    Common.Main.update commonMsg model.common
            in
            ( { model | common = commonModel }, Cmd.batch [ Cmd.map GotCommonMsg commonCmd ] )


withCommon : Common.Model.Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
withCommon commonMsg ( model, cmds ) =
    let
        ( commonModel, commonCmd ) =
            Common.Main.update commonMsg model.common
    in
    ( { model | common = commonModel }, Cmd.batch [ cmds, Cmd.map GotCommonMsg commonCmd ] )


getGlobaleEffects : Msg -> Model -> ( Model, Cmd msg )
getGlobaleEffects msg model =
    let
        isSingleRoute =
            case model.navigation.route of
                SingleRoute _ ->
                    True

                _ ->
                    False

        isDeletingNote =
            case msg of
                GotCommonMsg commonMsg ->
                    case commonMsg of
                        Common.Model.DelNote _ ->
                            True

                        _ ->
                            False

                _ ->
                    False

        isDeletingNoteFromSinglePage =
            isSingleRoute && isDeletingNote

        isCopyingNoteFromSinglePage =
            model.singlePage.isCopyingNote

        maybeNewNote =
            case msg of
                GotListMsg listMsg ->
                    case listMsg of
                        GotNotes notes ->
                            notes |> List.sortWith newestFirst |> List.head

                        _ ->
                            Nothing

                _ ->
                    Nothing

        newNoteId =
            case maybeNewNote of
                Just note ->
                    note.id

                Nothing ->
                    ""
    in
    if isDeletingNoteFromSinglePage then
        ( model, sendUrlChangeRequest model.navigation.basePath )

    else if isCopyingNoteFromSinglePage && (newNoteId /= "") then
        let
            singleModel =
                model.singlePage
        in
        ( { model | singlePage = { singleModel | isCopyingNote = False } }, sendUrlChangeRequest (model.navigation.basePath ++ "note/" ++ newNoteId) )

    else
        ( model, Cmd.none )


withGlobalEffects : (Msg -> Model -> ( Model, Cmd Msg )) -> Msg -> Model -> ( Model, Cmd Msg )
withGlobalEffects updateFn msg model =
    let
        ( updatedModel, cmd ) =
            updateFn msg model

        ( modelAfterEffect, effectCmd ) =
            getGlobaleEffects msg updatedModel
    in
    ( modelAfterEffect, Cmd.batch [ cmd, effectCmd ] )


type alias Flags =
    { basePath : String }


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = withGlobalEffects update
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

        commonModel =
            Common.Main.init
    in
    ( { navigation =
            { key = navigationKey
            , route = route
            , basePath = basePath
            }
      , listPage = listPageModel
      , singlePage = singlePageModel
      , common = commonModel
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
