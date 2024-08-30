module MainTest exposing (..)

import Expect
import Main exposing (..)
import Mockers exposing (mockedTextNote)
import Router exposing (..)
import Test exposing (..)


getTitleTest : Test
getTitleTest =
    describe "getTitle"
        [ test "it returns 'notebook' in list page" <|
            \_ ->
                getTitle ListRoute (Just mockedTextNote)
                    |> Expect.equal "Notebook"
        , test "It returns 'notebook' + the note title in single page" <|
            \_ ->
                getTitle (SingleRoute "1") (Just mockedTextNote)
                    |> Expect.equal "Notebook - fake title"
        ]
