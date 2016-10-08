module SquareGrid exposing (..)

import Element exposing (..)
import Color exposing (..)
import Collage exposing (..)
import List


main =
    let
        squares =
            List.repeat (rows ^ 2) (makeSquare blue (squareSize - 1))
                |> List.indexedMap (\i square -> move ( x i, y i ) square)

        x i =
            squareSize * (toFloat (row i))

        y i =
            squareSize * (toFloat (col i))

        makeSquare color size =
            filled color (square size)

        rows =
            8

        -- Acutally the size will be one less, so we can see the gaps ;)
        squareSize =
            50

        row i =
            i // rows

        col i =
            i % rows
    in
        toHtml <|
            collage (squareSize * 20) (squareSize * 20) squares
