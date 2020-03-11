module Pages.Posts exposing (view)

import Ssr.Attributes exposing (class, href)
import Ssr.Document exposing (Document)
import Ssr.Html exposing (..)


view : Document msg
view =
    { meta =
        { title = "posts | rhg.dev"
        , description = "the latest and greatest."
        , image = "https://avatars2.githubusercontent.com/u/6187256"
        }
    , body =
        [ h1 [] [ text "Posts" ]
        , ul []
            [ li [] [ p [] [ a [ href "/posts/code-generation" ] [ text "code generation" ] ] ]
            , li [] [ p [] [ a [ href "/posts/elm-canvas-thing" ] [ text "elm canvas thing" ] ] ]
            ]
        ]
    }
