module SquareGrid exposing (..)

import Element exposing (..)
import Color exposing (..)
import Collage exposing (..)
import Text exposing (color, fromString)
import List
import Array

import Array2D

rows =
    10


squareSize =
    -- Actually the size will be one less, so we can see the gaps ;)
    60


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

-- ================================================================================

gridOfSquares color size numPerSide =
  let
    initialSquare = filled color (square size)
    sampleArray = Array2D.repeat numPerSide numPerSide initialSquare
  in
    Array2D.indexedMap
      moveShapeToCellPosition
      sampleArray

moveShapeToCellPosition row col cell =
  move (squareSize * (toFloat row), squareSize * (toFloat col)  ) cell

flatten2DArrayToList : Array2D.Array2D a -> List a
flatten2DArrayToList arrayOfArrays =
    Array.foldl
      (\curArray listSoFar -> List.append (Array.toList curArray) listSoFar )
      []
      arrayOfArrays.data


main =
  let
    someSquares =
      (flatten2DArrayToList (gridOfSquares blue (squareSize - 1) 8) )

  in
    toHtml <|
        collage (squareSize * 20) (squareSize * 20) someSquares -- (flatten2DArrayToList (gridOfSquares blue 60 5).data)
