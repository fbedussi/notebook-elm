module TestUtils exposing (..)
import Test.Html.Selector
import Html.Attributes

testId id = 
    Test.Html.Selector.attribute <| Html.Attributes.attribute "data-testid" <| id