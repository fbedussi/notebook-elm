module Common.MainTest exposing (..)

import Common.Main exposing (init, view)
import Html exposing (div)
import Mockers exposing (mockedNote)
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
                div [] (view { model | noteToDelete = Just mockedNote })
                    |> Query.fromHtml
                    |> Query.has [ id "del-note-dialog" ]
        ]
