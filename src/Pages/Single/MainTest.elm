module Pages.Single.MainTest exposing (..)

import Html exposing (div)
import Html.Attributes
import Pages.Single.Main exposing (init, view)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector


mainTest : Test
mainTest =
    describe "it renders correctly"
        [ test "has the back button" <|
            \_ ->
                div [] (view (Tuple.first (init "1")))
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "back-btn" ]
        ]
