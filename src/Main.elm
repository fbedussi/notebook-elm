module Main exposing (getTitle, main, view)

import Backend
import Browser
import Browser.Navigation as Nav
import Common.Main exposing (setShowBackButton)
import Common.Model
import Constants exposing (..)
import Html exposing (..)
import Model exposing (Note)
import Pages.List.Main as ListPage
import Pages.List.Model exposing (Msg(..))
import Pages.Login.Main as LoginPage
import Pages.Login.Model
import Pages.Single.Main as SinglePage
import Pages.Single.Model
import Router exposing (Route(..), parseUrl, performUrlChange, sendUrlChangeRequest)
import Url exposing (Url)
import Url.Parser exposing ((</>))


type alias Navigation =
    { key : Nav.Key
    , route : Route
    , basePath : String
    }


type alias Model =
    { navigation : Navigation
    , loginPage : Pages.Login.Model.Model
    , listPage : Pages.List.Model.Model
    , singlePage : Pages.Single.Model.Model
    , common : Common.Model.Model
    , userId : String
    }


view : Model -> Browser.Document Msg
view model =
    let
        commonContent =
            Common.Main.view model.common
                |> List.map (Html.map GotCommonMsg)

        pageContent =
            case model.navigation.route of
                LoginRoute ->
                    LoginPage.view model.loginPage
                        |> List.map (Html.map GotLoginMsg)

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
    | GotLoginMsg Pages.Login.Model.Msg
    | GotListMsg Pages.List.Model.Msg
    | GotSingleMsg Pages.Single.Model.Msg
    | GotCommonMsg Common.Model.Msg
    | LoggedIn String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoggedIn userId ->
            ( { model | userId = userId }, sendUrlChangeRequest "" )

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
                        LoginRoute ->
                            Cmd.none

                        SingleRoute id ->
                            Backend.getNote id

                        ListRoute ->
                            Backend.getNotes ()

                        NotFoundRoute ->
                            Cmd.none

                navigation =
                    model.navigation

                commonModel =
                    model.common
                        |> setShowBackButton route
            in
            ( { model | navigation = { navigation | route = route }, common = commonModel }
            , cmd
            )

        GotLoginMsg loginMsg ->
            let
                ( loginModel, loginCmd ) =
                    LoginPage.update loginMsg model.loginPage
            in
            ( { model | loginPage = loginModel }, loginCmd |> Cmd.map GotLoginMsg )

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

                        redirectToSinglePage noteId =
                            sendUrlChangeRequest (model.navigation.basePath ++ "note/" ++ noteId)

                        ( singleModel, singleCmd, commonMsg ) =
                            SinglePage.update redirectToSinglePage singleMsg { oldSingleModel | id = id }
                    in
                    ( { model | singlePage = singleModel }, Cmd.map GotSingleMsg singleCmd )
                        |> withCommon commonMsg

                _ ->
                    ( model, Cmd.none )

        GotCommonMsg commonMsg ->
            let
                ( commonModel, commonCmd ) =
                    Common.Main.update (redirectToListPage model) commonMsg model.common
            in
            ( { model | common = commonModel }, Cmd.batch [ Cmd.map GotCommonMsg commonCmd ] )


withCommon : Common.Model.Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
withCommon commonMsg ( model, cmds ) =
    let
        ( commonModel, commonCmd ) =
            Common.Main.update (redirectToListPage model) commonMsg model.common
    in
    ( { model | common = commonModel }, Cmd.batch [ cmds, Cmd.map GotCommonMsg commonCmd ] )


redirectToListPage model () =
    let
        isListRoute =
            case model.navigation.route of
                ListRoute ->
                    True

                _ ->
                    False
    in
    if not isListRoute then
        sendUrlChangeRequest model.navigation.basePath

    else
        Cmd.none


type alias Flags =
    { basePath : String, userId : String }


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
init { basePath, userId } url navigationKey =
    let
        route =
            parseUrl basePath url

        selectedNoteId =
            case route of
                SingleRoute id ->
                    id

                _ ->
                    ""

        loginPageModel =
            LoginPage.init

        ( listPageModel, listPageCmd ) =
            ListPage.init ()

        ( singlePageModel, singlePageCmd ) =
            SinglePage.init selectedNoteId

        commonModel =
            Common.Main.init
                |> setShowBackButton route

        notLoggedIn =
            userId == ""
    in
    ( { navigation =
            { key = navigationKey
            , route =
                if notLoggedIn then
                    LoginRoute

                else
                    route
            , basePath = basePath
            }
      , loginPage = loginPageModel
      , listPage = listPageModel
      , singlePage = singlePageModel
      , common = commonModel
      , userId = userId
      }
    , Cmd.batch
        [ if notLoggedIn then
            sendUrlChangeRequest "login"

          else
            Cmd.none
        , singlePageCmd |> Cmd.map GotSingleMsg
        , listPageCmd |> Cmd.map GotListMsg
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ performUrlChange PerformUrlChange
        , ListPage.subscriptions ()
            |> Sub.map GotListMsg
        , SinglePage.subscriptions ()
            |> Sub.map GotSingleMsg
        , Backend.loggedIn LoggedIn
        ]
