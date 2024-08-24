port module Router exposing (..)

import Model exposing (Id)
import Url exposing (Url)
import Url.Parser exposing ((</>))


port sendUrlChangeRequest : String -> Cmd msg


port performUrlChange : (String -> msg) -> Sub msg


type Route
    = LoginRoute
    | ListRoute
    | SingleRoute Id
    | NotFoundRoute


parseUrl : String -> Url -> Route
parseUrl basePath url =
    let
        parse =
            Url.Parser.oneOf
                [ Url.Parser.map ListRoute Url.Parser.top
                , Url.Parser.map LoginRoute (Url.Parser.s "login")
                , Url.Parser.map SingleRoute (Url.Parser.s "note" </> Url.Parser.string)
                ]
                |> Url.Parser.parse
    in
    parse { url | path = String.replace basePath "" url.path }
        |> Maybe.withDefault NotFoundRoute
