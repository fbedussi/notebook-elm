module Pages.Login.Model exposing (..)


type Msg
    = UpdateUsername String
    | UpdatePassword String
    | Login


type alias Model =
    { username : String
    , password : String
    }
