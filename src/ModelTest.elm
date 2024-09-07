module ModelTest exposing (..)

import Expect
import Model exposing (updateTodosWitText)
import Test exposing (describe, test)


updateTodosWitTextTest =
    describe "updateTodosWitText"
        [ test "adds an empty todo when filling in the last one" <|
            \_ ->
                updateTodosWitText { todoId = "2", text = "b", todos = [ { id = "1", done = False, text = "a" }, { id = "2", done = False, text = "" } ] }
                    |> List.length
                    |> Expect.equal 3
        ]
