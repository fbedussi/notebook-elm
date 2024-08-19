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
    , version: Int
    }


type alias Notes =
    List Note
