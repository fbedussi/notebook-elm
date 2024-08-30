module Common.MainTest exposing (..)

import Common.Main exposing (init, setShowBackButton, view)
import Html exposing (div)
import Html.Attributes
import Mockers exposing (mockedTextNote)
import Router exposing (Route(..))
import Test exposing (describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id)


viewTest =
    describe "delete note modal" <|
        [ test "it is hidden by default" <|
            \_ ->
                let
                    model =
                        init
                in
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.hasNot [ id "del-note-dialog" ]
        , test "it is shown it there is a note to delete" <|
            \_ ->
                let
                    model =
                        init
                in
                div [] (view { model | noteToDelete = Just mockedTextNote })
                    |> Query.fromHtml
                    |> Query.has [ id "del-note-dialog" ]
        ]


backButtonTest =
    describe "back button" <|
        [ test "it is shown in single page" <|
            \_ ->
                let
                    model =
                        init
                            |> setShowBackButton (SingleRoute "")
                in
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "back-btn"
                        ]
        , test "it is hidden in single page" <|
            \_ ->
                let
                    model =
                        init
                            |> setShowBackButton ListRoute
                in
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.hasNot
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "back-btn"
                        ]
        , test "it is hidden in login page" <|
            \_ ->
                let
                    model =
                        init
                            |> setShowBackButton LoginRoute
                in
                div [] (view model)
                    |> Query.fromHtml
                    |> Query.hasNot
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "back-btn"
                        ]
        ]
