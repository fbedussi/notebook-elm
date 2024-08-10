module Main exposing
    ( main
    , Model, Msg(..), Effect(..), init, update, view, Route(..)
    )

{-|

@docs main


# Exposed for tests

@docs Model, Msg, Effect, init, update, view, Route, routeToString

-}

import Browser
import Browser.Navigation as Navigation
import Html exposing (..)
import Html.Attributes exposing (classList, href)
import Html.Events exposing (onClick)
import Pages.Counter as Counter
import Pages.Survey as Survey
import Process
import Task
import Url exposing (Url)
import Url.Parser exposing ((</>))


type alias Model navigationKey =
    { page : Page
    , navigationKey : navigationKey
    }


type Route
    = CounterRoute
    | SurveyRoute


type Page
    = CounterPage Counter.Model
    | SurveyPage Survey.Model
    | NotFound


routeParser : Url.Parser.Parser (Route -> a) a
routeParser =
    Url.Parser.oneOf
        [ Url.Parser.map CounterRoute Url.Parser.top
        , Url.Parser.map SurveyRoute (Url.Parser.s "survey")
        ]


view : Model navigationKey -> Browser.Document Msg
view model =
    let
        content =
            case model.page of
                CounterPage counterModel ->
                    Counter.view counterModel
                        |> Html.map GotCounterMsg

                SurveyPage surveyModel ->
                    Survey.view surveyModel
                        |> Html.map GotSurveyMsg

                NotFound ->
                    text "Sorry, I did't find this page"
    in
    { title = "Elm SPA Boilerplate"
    , body =
        [ viewHeader model.page
        , main_ []
            [ content ]
        , footer []
            [ text "Elm SPA boilerplate"
            ]
        ]
    }


viewHeader : Page -> Html msg
viewHeader activePage =
    header []
        [ nav []
            [ ul []
                [ navLink (isLinkActive ( CounterRoute, activePage )) { url = "/", label = "Counter" }
                , navLink (isLinkActive ( SurveyRoute, activePage )) { url = "/survey", label = "Survey" }
                ]
            ]
        ]


isLinkActive : ( Route, Page ) -> Bool
isLinkActive ( route, page ) =
    case ( route, page ) of
        ( CounterRoute, CounterPage _ ) ->
            True

        ( CounterRoute, _ ) ->
            False

        ( SurveyRoute, SurveyPage _ ) ->
            False

        ( SurveyRoute, _ ) ->
            False


navLink : Bool -> { a | url : String, label : String } -> Html msg
navLink isActive { url, label } =
    a [ href url, classList [ ( "active", isActive ) ] ] [ text label ]


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | GotCounterMsg Counter.Msg
    | GotSurveyMsg Survey.Msg


update : Msg -> Model navigationKey -> ( Model navigationKey, Effect )
update msg model =
    case msg of
        ClickedLink (Browser.Internal url) ->
            ( model, PushUrl (Url.toString url) )

        ClickedLink (Browser.External string) ->
            ( model, Load string )

        ChangedUrl url ->
            ( { model | page = updateUrl url }
            , NoEffect
            )

        GotCounterMsg counterMsg ->
            case model.page of
                CounterPage counterModel ->
                    ( { model | page = CounterPage (Tuple.first (Counter.update counterMsg counterModel)) }, NoEffect )

                _ ->
                    ( model, NoEffect )

        GotSurveyMsg surveyMsg ->
            case model.page of
                SurveyPage surveyModel ->
                    ( { model | page = SurveyPage (Tuple.first (Survey.update surveyMsg surveyModel)) }, NoEffect )

                _ ->
                    ( model, NoEffect )


updateUrl : Url -> Page
updateUrl url =
    case Url.Parser.parse routeParser url of
        Just CounterRoute ->
            CounterPage (Counter.init 0)

        Just SurveyRoute ->
            SurveyPage (Survey.init False)

        Nothing ->
            NotFound


type alias Flags =
    ()


main : Program Flags (Model Navigation.Key) Msg
main =
    let
        performEffect ( model, effect ) =
            ( model, perform model.navigationKey effect )
    in
    Browser.application
        { init = \flags url key -> init flags url key |> performEffect
        , view = view
        , update = \msg model -> update msg model |> performEffect
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }


init : flags -> Url -> navigationKey -> ( Model navigationKey, Effect )
init _ url navigationKey =
    ( { page = updateUrl url
      , navigationKey = navigationKey
      }
    , NoEffect
    )


type Effect
    = NoEffect
    | PushUrl String
    | Load String


perform : Navigation.Key -> Effect -> Cmd Msg
perform navigationKey effect =
    case effect of
        NoEffect ->
            Cmd.none

        PushUrl string ->
            Navigation.pushUrl navigationKey string

        Load string ->
            Navigation.load string
