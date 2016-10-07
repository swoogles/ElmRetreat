module Square exposing (..)

import Color exposing (..)
import Element exposing (..)
import Collage exposing (..)
import List

main =
  toHtml <| collage 300 300
    [makeSquare blue 75 ]

makeSquare color size =
  filled color (square size)
