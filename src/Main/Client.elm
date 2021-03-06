module Main.Client exposing (main)

import Browser
import Browser.Navigation as Nav
import Pages
import Ports
import Process
import Route
import Ssr.Document
import Task
import Transition exposing (Transition)
import Url


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }



-- INIT


type alias Flags =
    ()


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , transition : Transition
    }


init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Model key url Transition.Visible
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | FadeIn Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        UrlChanged url ->
            ( { model | transition = Transition.Invisible }
            , delay 250 (FadeIn url)
            )

        FadeIn url ->
            ( { model | url = url, transition = Transition.Visible }
            , url
                |> Route.fromUrl
                |> Pages.view { transition = model.transition }
                |> .meta
                |> Ports.afterNavigate
            )


delay : Float -> msg -> Cmd msg
delay ms msg =
    Process.sleep ms
        |> Task.map (\_ -> msg)
        |> Task.perform identity


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    model.url
        |> Route.fromUrl
        |> Pages.view { transition = model.transition }
        |> Ssr.Document.toDocument
