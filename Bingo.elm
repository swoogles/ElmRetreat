module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (toUpper, repeat, trimRight)

title  message times =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text

pageHeader =
  h1 [] [title "bingo!" 3]

pageFooter =
  footer []
    [a [href "https://jceri.se"]
       [text "Jeremy Cerise"]
    ]

entryList =
  ul [ ] [ li [] [text "Furture -Proof"] ]

view =
  div [ id "container" ]
    [pageHeader,
     entryList,
     pageFooter]

main =
  view
