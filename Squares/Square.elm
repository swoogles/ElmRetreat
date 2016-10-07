module Square exposing (..)

import Color exposing (..)
import Element exposing (..)
import Collage exposing (..)
import Text exposing (..)

main =
  toHtml <| makeCollage 200 500

message msg =
  text (Text.color white (fromString msg))

makeSquare color msg =
  group [filled color (square 75), message msg ]

makeCollage x y =
  let
    a = makeSquare blue "Bob"
    b = move (0, -100) (makeSquare red "elm")
  in
    collage x y [a, b]

