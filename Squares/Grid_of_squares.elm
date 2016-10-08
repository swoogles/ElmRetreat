module SquareGrid exposing (..)

import Element exposing (..)
import Color exposing (..)
import Collage exposing (..)
import Text exposing (..)
import List


rows =
    10


squareSize =
    -- Actually the size will be one less, so we can see the gaps ;)
    50


message msg =
    text (Text.color white (fromString msg))


xDist i =
    squareSize * (toFloat (row i))


yDist i =
    squareSize * (toFloat (col i))


row i =
    i // rows


col i =
    i % rows


makeSquare color size msg =
    group
        [ filled color (square size), message msg ]


squares =
    List.repeat (rows ^ 2) (makeSquare blue (squareSize - 1) "foo")


squareGrid =
    List.indexedMap (\i square -> move ( xDist i, yDist i ) square) squares


main =
    toHtml <|
        collage (squareSize * 20) (squareSize * 20) squareGrid
