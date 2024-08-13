module MainTest exposing (..)

import Fuzz exposing (intRange, string)
import Html.Attributes exposing (href)
import Main exposing (..)
import ProgramTest exposing (..)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, containing, tag, text)


viewHeaderTest : Test
viewHeaderTest =
    describe "View header"
        [ test "Renders the 2 links" <|
            \_ ->
                viewHeader CounterRoute "user1"
                    |> Query.fromHtml
                    |> Query.has [ text "Counter", text "Survey" ]
        , fuzz (intRange 0 1) "The link to the current route has the active class" <|
            \a ->
                let
                    ( route, label ) =
                        case a of
                            0 ->
                                ( CounterRoute, "Counter" )

                            _ ->
                                ( SurveyRoute "", "Survey" )
                in
                viewHeader route "user1"
                    |> Query.fromHtml
                    |> Query.has [ class "active", containing [ text label ] ]
        , fuzz string "The link to the survay page has the user name in label and in url" <|
            \userName ->
                viewHeader CounterRoute userName
                    |> Query.fromHtml
                    |> Query.find [ tag "a", containing [ text <| "Survey " ++ userName ] ]
                    |> Query.has [ attribute <| href <| "/survey/" ++ userName ]
        ]
