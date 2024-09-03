module Styleguide.Preview exposing (..)

import Components.TodoNoteForm exposing (totdoNoteForm)
import ElmBook exposing (..)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (..)
import Html exposing (div, text)
import Html.Attributes exposing (class, style)
import Styleguide.Button exposing (button)
import Styleguide.Icons.Back exposing (backIcon)
import Styleguide.Icons.Copy exposing (copyIcon)
import Styleguide.Icons.Delete exposing (deleteIcon)
import Styleguide.RadioGroup exposing (radioGroup)
import Styleguide.TextBox exposing (textBox)


wrapper view =
    div
        [ style "padding" "1rem", class "pico" ]
        [ view ]


withWrapper ( label, view ) =
    ( label, wrapper view )


renderComponentListWithWrapper componentList =
    renderComponentList
        (List.map withWrapper componentList)


icons =
    chapter "Icons"
        |> renderComponentListWithWrapper
            [ ( "Back Icon", backIcon )
            , ( "Copy Icon", copyIcon )
            ]


buttons =
    chapter "Buttons"
        |> renderComponentListWithWrapper
            [ ( "Primary button", button [] [ text "Hello!" ] )
            , ( "Secondary button", button [ class "secondary" ] [ text "Hello!" ] )
            ]


inputs =
    let
        onCheckMsg =
            \value checked ->
                logAction
                    ("Radio changed "
                        ++ value
                        ++ (if checked then
                                " checked"

                            else
                                "not checked"
                           )
                    )

        deleteBtn =
            button [ class "no-style" ] [ deleteIcon ]
    in
    chapter "Inputs"
        |> renderComponentListWithWrapper
            [ ( "Text box", textBox { labelAttributes = [], inputAttributes = [], endElement = Nothing } "My text input" )
            , ( "Text box with reset button", textBox { labelAttributes = [], inputAttributes = [], endElement = Just deleteBtn } "My text input" )
            , ( "Radio group", radioGroup { groupLabel = "Group label", groupName = "test", options = [ { value = "one", label = "one" }, { value = "two", label = "two" } ] } onCheckMsg "one" )
            ]


tokens =
    let
        todo =
            { id = "1", done = False, text = "First task" }

        updateDoneMsg =
            \id done ->
                logAction
                    ("Task "
                        ++ id
                        ++ (if done then
                                " done"

                            else
                                " not done"
                           )
                    )

        updateTextMsg =
            \id text -> logAction ("Task " ++ id ++ " " ++ text)
    in
    chapter "Tokens"
        |> renderComponentListWithWrapper
            [ ( "totdoNoteForm", totdoNoteForm updateDoneMsg updateTextMsg todo ) ]


main : Book ()
main =
    book "Notebbok styleguide"
        |> withChapters
            [ icons
            , buttons
            , inputs
            , tokens
            ]
