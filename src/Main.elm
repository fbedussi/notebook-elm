module Main exposing (Route(..), main, viewHeader)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (classList, href)
import Pages.Counter
import Pages.Survey
import Url exposing (Url)
import Url.Parser exposing ((</>))


type alias Model =
    { navigationKey : Nav.Key
    , route : Route
    , counterPage : Pages.Counter.Model
    , surveyPage : Pages.Survey.Model
    }


type Route
    = CounterRoute
    | SurveyRoute String
    | NotFoundRoute


parseUrl : Url -> Route
parseUrl url =
    let
        parse =
            Url.Parser.oneOf
                [ Url.Parser.map CounterRoute Url.Parser.top
                , Url.Parser.map SurveyRoute (Url.Parser.s "survey" </> Url.Parser.string)
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
                CounterRoute ->
                    Pages.Counter.view model.counterPage
                        |> Html.map GotCounterMsg

                SurveyRoute userName ->
                    let
                        survayModel =
                            model.surveyPage
                    in
                    Pages.Survey.view { survayModel | name = userName }
                        |> Html.map GotSurveyMsg

                NotFoundRoute ->
                    text "Sorry, I did't find this page"
    in
    { title = getTitle model.route
    , body =
        [ viewHeader model.route model.surveyPage.name
        , main_ []
            [ content ]
        , footer []
            [ text "Elm SPA boilerplate"
            ]
        ]
    }


getTitle : Route -> String
getTitle route =
    case route of
        CounterRoute ->
            "Elm SPA boilerplate - Counter"

        SurveyRoute _ ->
            "Elm SPA boilerplate - Survay"

        _ ->
            "Elm SPA boilerplate"


viewHeader : Route -> String -> Html msg
viewHeader activeRoute userName =
    let
        isActive : Route -> Route -> Bool
        isActive routeA routeB =
            case ( routeA, routeB ) of
                ( CounterRoute, CounterRoute ) ->
                    True

                ( SurveyRoute _, SurveyRoute _ ) ->
                    True

                ( _, _ ) ->
                    False
    in
    header []
        [ nav []
            [ ul []
                [ navLink (isActive activeRoute CounterRoute) { url = "/", label = "Counter" }
                , navLink (isActive activeRoute (SurveyRoute "")) { url = "/survey/" ++ userName, label = "Survey " ++ userName }
                ]
            ]
        ]


navLink : Bool -> { a | url : String, label : String } -> Html msg
navLink isActive { url, label } =
    a [ href url, classList [ ( "active", isActive ) ] ] [ text label ]


type Msg
    = ClickedLink Browser.UrlRequest
    | ChangedUrl Url
    | GotCounterMsg Pages.Counter.Msg
    | GotSurveyMsg Pages.Survey.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedLink (Browser.Internal url) ->
            ( model, Nav.pushUrl model.navigationKey (Url.toString url) )

        ClickedLink (Browser.External string) ->
            ( model, Nav.load string )

        ChangedUrl url ->
            ( { model | route = parseUrl url }
            , Cmd.none
            )

        GotCounterMsg counterMsg ->
            -- in this case we will update the model and run commands only if we are in the Counter page
            case model.route of
                CounterRoute ->
                    let
                        ( counterModel, counterCmd ) =
                            Pages.Counter.update counterMsg model.counterPage
                    in
                    ( { model | counterPage = counterModel }, Cmd.map GotCounterMsg counterCmd )

                _ ->
                    ( model, Cmd.none )

        GotSurveyMsg surveyMsg ->
            {- in this case we will update the page model and run the commands even if we are not in the Survay page
               because the userName that we will use in the survay page is sent at the page boot
            -}
            let
                ( survayModel, survayCmd ) =
                    Pages.Survey.update surveyMsg model.surveyPage
            in
            ( { model | surveyPage = survayModel }, Cmd.map GotSurveyMsg survayCmd )


type alias Flags =
    Int


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
init initialCounter url navigationKey =
    ( { route = parseUrl url
      , counterPage = Pages.Counter.init initialCounter
      , surveyPage = Pages.Survey.init False "no-name"
      , navigationKey = navigationKey
      }
    , Cmd.none
    )


subscriptions : { a | route : Route, surveyPage : Pages.Survey.Model } -> Sub Msg
subscriptions model =
    Pages.Survey.subscriptions model.surveyPage
        |> Sub.map GotSurveyMsg
