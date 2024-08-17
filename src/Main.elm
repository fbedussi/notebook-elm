port module Main exposing (Route(..), main, getTitle)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Model exposing (Id, Note)
import Pages.List.Main as ListPage
import Pages.List.Model
import Pages.Single
import Url exposing (Url)
import Url.Parser exposing ((</>))


type alias Model =
    { navigationKey : Nav.Key
    , route : Route
    , listPage : Pages.List.Model.Model
    , singlePage : Pages.Single.Model
    }


type Route
    = ListRoute
    | SingleRoute Id
    | NotFoundRoute


parseUrl : Url -> Route
parseUrl url =
    let
        parse =
            Url.Parser.oneOf
                [ Url.Parser.map ListRoute Url.Parser.top
                , Url.Parser.map SingleRoute (Url.Parser.s "note" </> Url.Parser.string)
                ]
                |> Url.Parser.parse
    in
    parse url
        |> Maybe.withDefault NotFoundRoute


view : Model -> Browser.Document Msg
view model =
    let
        content =
            case model.route of
                ListRoute ->
                    ListPage.view model.listPage
                        |> List.map (Html.map GotListMsg)

                SingleRoute id ->
                    let
                        singleModel =
                            model.singlePage
                    in
                    Pages.Single.view { singleModel | id = id }
                        |> List.map (Html.map GotSingleMsg)

                NotFoundRoute ->
                    [ text "Sorry, I did't find this page" ]
    in
    { title =
        getTitle model.route model.singlePage.note
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
    | GotSingleMsg Pages.Single.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink (Browser.Internal url) ->
            ( model, Url.toString url |> sendUrlChangeRequest )

        ClickedLink (Browser.External string) ->
            ( model, Nav.load string )

        PerformUrlChange urlString ->
            ( model, Nav.pushUrl model.navigationKey urlString )

        ChangedUrl url ->
            ( { model | route = parseUrl url }
            , Cmd.none
            )

        GotListMsg listMsg ->
            case model.route of
                ListRoute ->
                    let
                        ( listMode, listCmd ) =
                            ListPage.update listMsg model.listPage
                    in
                    ( { model | listPage = listMode }, Cmd.map GotListMsg listCmd )

                _ ->
                    ( model, Cmd.none )

        GotSingleMsg singleMsg ->
            case model.route of
                SingleRoute id ->
                    let
                        ( singleModel, singleCmd ) =
                            Pages.Single.update singleMsg { id = id, note = Nothing }
                    in
                    ( { model | singlePage = singleModel }, Cmd.map GotSingleMsg singleCmd )

                _ ->
                    ( model, Cmd.none )


port sendUrlChangeRequest : String -> Cmd msg


port performUrlChange : (String -> msg) -> Sub msg


type alias Flags =
    ()


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
init () url navigationKey =
    let
        route =
            parseUrl url

        selectedNoteId =
            case route of
                SingleRoute id ->
                    id

                _ ->
                    ""
    in
    ( { navigationKey = navigationKey
      , route = route
      , listPage = ListPage.init ()
      , singlePage = Pages.Single.init selectedNoteId
      }
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    ListPage.subscriptions ()
        |> Sub.map GotListMsg
