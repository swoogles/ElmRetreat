module Bingo exposing (..)

import Html exposing (..)
import Html.App as App
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
  |Delete Int

update action model =
  case action of
    NoOp ->
      model

    Sort ->
      { model | entries = List.sortBy .points model.entries }

    Delete id ->
      let
        remainingEntries =
          List.filter (\e -> e.id /= id) model.entries
      in
        { model | entries = remainingEntries }

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
    span [class "points"] [text (toString entry.points) ],
    button [class "delete", onClick (Delete entry.id)] []
  ]

entryList entries =
  let
    entryItems = List.map entryItem entries
  in
    ul [ ] entryItems

view model =
  div [ id "container" ]
    [pageHeader,
     entryList model.entries,
     button [class "sort", onClick Sort] [text "Sort"],
     pageFooter]

-- Wire it all together
main =
    App.beginnerProgram {model = initialModel, view = view, update = update}
