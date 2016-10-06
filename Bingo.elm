module Bingo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (toUpper, repeat, trimRight)

-- Model
initialModel =
  {entries = [newEntry "Doing Agile" 200 2,
              newEntry "In the Cloud" 300 3,
              newEntry "Future-proof" 100 1,
              newEntry "RockStar Ninja" 400 4]
  }

newEntry phrase points id =
  {
    phrase = phrase,
    points = points,
    wasSpoken = False,
    id = id
  }

-- update

type Action
  = NoOp
  | Sort

update action model =
  case action of
    NoOp ->
      model

    Sort ->
      { model | entries = List.sortBy .points model.entries }

-- View
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

entryItem entry =
  li [] [
    span [class "phrase"] [text entry.phrase],
    span [class "points"] [text (toString entry.points) ]
  ]

entryList entries =
  ul [ ] (List.map entryItem entries)

view model =
  div [ id "container" ]
    [pageHeader,
     entryList model.entries,
     pageFooter]

-- Wire it all together
main =
  initialModel
    |> update Sort
    |> view
