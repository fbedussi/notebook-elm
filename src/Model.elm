module Model exposing (..)

import Time


type alias Id =
    String


type alias Note =
    { id : Id
    , title : String
    , text : String
    , createdAt : Time.Posix
    , updatedAt : Time.Posix
    }


type alias Notes =
    List Note
