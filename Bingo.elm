module Bingo exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String exposing (toUpper, repeat, trimRight)
import BingoUtils as Utils

-- Model
type alias Entry = {phrase: String, points: Int, wasSpoken: Bool, id: Int}
type alias Model = {entries: List Entry,
                    phraseInput: String,
                    pointsInput: String,
                    nextId: Int}

initialModel : Model
initialModel =
  {entries = [newEntry "Doing Agile" 200 2,
              newEntry "In the Cloud" 300 3,
              newEntry "Future-proof" 100 1,
              newEntry "RockStar Ninja" 400 4],
              phraseInput = "",
              pointsInput = "",
              nextId = 5
  }

newEntry : String -> Int -> Int -> Entry
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
  | Delete Int
  | Mark Int
  | UpdatePhraseInput String
  | UpdatePointsInput String
  | Add



update : Action -> Model -> Model
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

    Mark id ->
      let
        updateEntry e =
          if e.id == id then { e | wasSpoken = (not e.wasSpoken) } else e
      in
        { model | entries = List.map updateEntry model.entries }

    UpdatePhraseInput contents ->
      { model | phraseInput = contents}

    UpdatePointsInput contents ->
      {model | pointsInput = contents}

    Add ->
      let
        entryToAdd =
          newEntry model.phraseInput (Utils.parseInt model.pointsInput) model.nextId
        isInvalid model =
          String.isEmpty model.phraseInput || String.isEmpty model.pointsInput
      in
        if isInvalid model
        then model
        else { model |
               phraseInput = "",
               pointsInput = "",
               entries = entryToAdd :: model.entries,
               nextId = model.nextId
             }

-- View

title : String -> Int -> Html action
title  message times =
  message ++ " "
    |> toUpper
    |> repeat times
    |> trimRight
    |> text

pageHeader : Html action
pageHeader =
  h1 [] [title "bingo!" 3]

pageFooter : Html action
pageFooter =
  footer []
    [a [href "https://jceri.se"]
       [text "Jeremy Cerise"]
    ]

entryItem : Entry -> Html Action
entryItem entry =
  li [classList [("highlight", entry.wasSpoken)], onClick (Mark entry.id)] [
    span [class "phrase"] [text entry.phrase],
    span [class "points"] [text (toString entry.points) ],
    button [class "delete", onClick (Delete entry.id)] []
  ]

totalPoints : List Entry -> Int
totalPoints entries =
  let
    spokenEntries = List.filter .wasSpoken entries
  in
    List.sum (List.map .points spokenEntries)

totalItem : Int -> Html action
totalItem total =
  li [class "total"]
     [span [class "label"] [text "Total"],
      span [class "points"] [text (toString total)]
    ]

entryList : List Entry -> Html Action
entryList entries =
  let
    entryItems = List.map entryItem entries
    items = entryItems ++ [totalItem (totalPoints entries)]
  in
    ul [ ] items

entryForm : Model -> Html Action
entryForm model =
  div [] [ input [type' "text", placeholder "Phrase", value model.phraseInput, name "phrase", autofocus True, onInput UpdatePhraseInput ] [],
           input [type' "number", placeholder "Points", value model.pointsInput, name "points", onInput UpdatePointsInput] [],
           button [class "add", onClick Add] [text "Add"],
           h2 [] [ text (model.phraseInput ++ " " ++ model.pointsInput)]]

view : Model -> Html Action
view model =
  div [ id "container" ]
    [pageHeader,
     entryForm model,
     entryList model.entries,
     button [class "sort", onClick Sort] [text "Sort"],
     pageFooter]

-- Wire it all together
main : Program Never
main =
    App.beginnerProgram {model = initialModel, view = view, update = update}
