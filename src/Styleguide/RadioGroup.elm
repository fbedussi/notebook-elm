module Styleguide.RadioGroup exposing (..)

import Html exposing (fieldset, input, label, legend, option, text)
import Html.Attributes exposing (checked, for, id, name, type_, value)
import Html.Events exposing (onCheck)
import HtmlUtils exposing (testId)


radioGroup { groupLabel, groupName, options } onCheckMsg selectedValue =
    fieldset
        [ testId ("choose-" ++ groupName) ]
        (legend
            []
            [ text groupLabel ]
            :: List.concatMap (singleRadio groupName selectedValue onCheckMsg) options
        )


singleRadio groupName selectedValue onCheckMsg option =
    [ input [ type_ "radio", id option.value, name groupName, checked (option.value == selectedValue), onCheck (onCheckMsg option.value) ] []
    , label [ for option.value ] [ text option.label ]
    ]
