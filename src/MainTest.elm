module MainTest exposing (..)

import Expect
import Main exposing (..)
import ProgramTest exposing (..)
import SimulatedEffect.Cmd
import SimulatedEffect.Navigation
import SimulatedEffect.Process
import SimulatedEffect.Task
import Test exposing (Test, describe, test)
import Test.Html.Selector exposing (text)
import Url


type alias MainTest =
    ProgramTest.ProgramTest (Model ()) Msg Effect


simulateEffect : Effect -> SimulatedEffect Msg
simulateEffect effect =
    case effect of
        NoEffect ->
            SimulatedEffect.Cmd.none

        Delay ms msg ->
            SimulatedEffect.Process.sleep ms
                |> SimulatedEffect.Task.perform (\() -> msg)

        PushUrl string ->
            SimulatedEffect.Navigation.pushUrl string

        Load string ->
            SimulatedEffect.Navigation.load string


start : String -> MainTest
start initialRoute =
    ProgramTest.createApplication
        { init = Main.init
        , view = Main.view
        , update = Main.update
        , onUrlRequest = Main.OnUrlRequest
        , onUrlChange = Main.OnUrlChange
        }
        |> ProgramTest.withBaseUrl ("https://example.com" ++ initialRoute)
        |> ProgramTest.withSimulatedEffects simulateEffect
        |> ProgramTest.start ()


mainViewTest : Test
mainViewTest =
    describe "Main view"
        [ test "it prints \"Home\"" <|
            \_ ->
                start ""
                    |> expectViewHas
                        [ text "Home"
                        ]
        ]


helpersTest : Test
helpersTest =
    describe "Helpers"
        [ test "routeToString" <|
            \_ ->
                routeToString Home
                    |> Expect.equal "Home"
        ]
