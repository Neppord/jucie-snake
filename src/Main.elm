module Main exposing (main)

import Browser exposing (document)
import Color
import Css exposing (animationDuration, animationName, ms, sec, vh, vmin)
import Css.Animations exposing (custom, keyframes, property)
import Css.Global exposing (global)
import Css.Transitions exposing (transition)
import Html.Styled exposing (toUnstyled)
import List.Extra
import TypedSvg exposing (rect, svg)
import TypedSvg.Attributes exposing (class, fill)
import TypedSvg.Attributes.InPx
    exposing
        ( height
        , width
        , x
        , y
        )
import TypedSvg.Types exposing (Paint(..))


main =
    document
        { init = \() -> ( (), Cmd.none )
        , view = always view
        , update = \_ m -> ( m, Cmd.none )
        , subscriptions = always Sub.none
        }


type alias Point =
    ( Int, Int )


type alias Snake =
    { head : Point
    , tail : List Direction
    }


type Direction
    = Up
    | Down
    | Left
    | Right


move : Direction -> Point -> Point
move direction ( xPos, yPos ) =
    case direction of
        Up ->
            ( xPos, yPos - 1 )

        Down ->
            ( xPos, yPos + 1 )

        Left ->
            ( xPos - 1, yPos )

        Right ->
            ( xPos + 1, yPos )


toCords snake =
    snake.head :: List.Extra.scanl move snake.head snake.tail


model =
    { snake =
        { head = ( 5, 5 )
        , tail = [ Right, Right, Right, Right, Down, Down, Left ]
        }
    }


view =
    { title = "Juice Snake"
    , body =
        [ toUnstyled css
        , model.snake
            |> toCords
            |> List.map snakeBody
            |> svg []
        ]
    }


css =
    global
        [ Css.Global.class "snake-body"
            [ animationName <|
                keyframes
                    [ ( 0
                      , [ property "x" "0"
                        , property "y" "1000"
                        ]
                      )
                    ]
            , animationDuration <| ms 500
            , Css.property "animation-timing-function" "ease-out"
            ]
        , Css.Global.svg
            [ Css.width <| vmin 100
            , Css.height <| vmin 100
            ]
        ]


snakeBody ( xPos, yPos ) =
    rect
        [ width 25
        , height 25
        , x <| toFloat xPos * 25
        , y <| toFloat yPos * 25
        , fill <| Paint Color.green
        , class [ "snake-body" ]
        ]
        []
