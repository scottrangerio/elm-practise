import Html exposing (..)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode

main =
  program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- Defines alias type
type alias Model =
  { topic : String
  , gifUrl : String
  }
  
-- Defines custom type
type Message
  = GetNewGif
  | NewGifResult (Result Http.Error String)

subscriptions model = 
  Sub.none

init topic =
  (Model topic "https://placehold.it/200x200", randomGif topic)

view: Model -> Html Message
view model =
    div [style [("text-align", "center")]]
      [ h1 [] [ text "Cat Gifs" ]
      , img [ src model.gifUrl, style [ ("width", "200px"), ("height", "200px") ]] []
      , div []
          [ button [ style [("display", "inline-block"), ("width", "200px"), ("height","30px")], onClick GetNewGif ] [ text "Get" ]
          ]
      ]

randomGif: String -> Cmd Message
randomGif topic =
  let
    url = "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
  in
    Http.send NewGifResult <| Http.get url decode

decode = 
  Decode.at ["data", "image_url"] Decode.string

update: Message -> Model -> (Model, Cmd Message)
update msg model =
  case msg of 
    GetNewGif ->
      (model, randomGif model.topic)
    
    NewGifResult (Ok newUrl) ->
      (Model model.topic newUrl, Cmd.none)

    NewGifResult (Err _) ->
      (model, Cmd.none)
