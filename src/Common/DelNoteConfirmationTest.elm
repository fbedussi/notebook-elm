module Common.DelNoteConfirmationTest exposing (..)

import Common.DelNoteConfirmation exposing (delNoteConfirmation)
import Html exposing (div)
import Html.Attributes
import Mockers exposing (mockedNote)
import Test exposing (describe, test)
import Test.Html.Query as Query
import Test.Html.Selector


delNoteConfirmationTest =
    describe "it renders correctly"
        [ test "it has a cancel button" <|
            \_ ->
                let
                    ( content, footerContent ) =
                        delNoteConfirmation mockedNote
                in
                div [] (content ++ footerContent)
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "cancel-btn"
                        ]
        , test "it has an ok button" <|
            \_ ->
                let
                    ( content, footerContent ) =
                        delNoteConfirmation mockedNote
                in
                div [] (content ++ footerContent)
                    |> Query.fromHtml
                    |> Query.has
                        [ Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| "ok-btn"
                        ]
        ]
