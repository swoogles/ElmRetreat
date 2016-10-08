import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Json exposing ((:=))
import Mouse exposing (Position)
import Svg exposing (..)
import Svg.Attributes exposing (..)



main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL


type alias Model =
    { position : Position
    , drag : Maybe Drag
    }


type alias Drag =
    { start : Position
    , current : Position
    }


init : ( Model, Cmd Msg )
init =
  ( Model (Position 200 200) Nothing, Cmd.none )



-- UPDATE


type Msg
    = DragStart Position
    | DragAt Position
    | DragEnd Position


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( updateHelp msg model, Cmd.none )


updateHelp : Msg -> Model -> Model
updateHelp msg ({position, drag} as model) =
  case msg of
    DragStart xy ->
      Model position (Just (Drag xy xy))

    DragAt xy ->
      Model position (Maybe.map (\{start} -> Drag start xy) drag)

    DragEnd _ ->
      Model (getPosition model) Nothing



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  case model.drag of
    Nothing ->
      Sub.none

    Just _ ->
      Sub.batch [ Mouse.moves DragAt, Mouse.ups DragEnd ]



-- VIEW


(=>) = (,)


view : Model -> Html Msg
view model =
  let
    realPosition =
      getPosition model
  in
    div
      [ Svg.onMouseDown
      ,   svg
          [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95"
          ]
          [  rect
              [ fill "#7FD13B", x "192.99", y "107.392", Svg.Attributes.width "50", Svg.Attributes.height "50"
              , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
              ]
              []
          ]
      ]


px : Int -> String
px number =
  toString number ++ "px"


getPosition : Model -> Position
getPosition {position, drag} =
  case drag of
    Nothing ->
      position

    Just {start,current} ->
      Position
        (position.x + current.x - start.x)
        (position.y + current.y - start.y)


onMouseDown : Attribute Msg
onMouseDown =
  on "mousedown" (Json.map DragStart Mouse.position)
