module Main exposing (main)

import Browser exposing (document)
import Css exposing (animationDelay, animationDuration, animationName, ms, vmin)
import Css.Animations exposing (keyframes, property)
import Css.Global exposing (global)
import Html.Styled exposing (toUnstyled)
import List.Extra
import String exposing (toInt)
import Svg.Styled exposing (rect, svg)
import Svg.Styled.Attributes exposing (class, css, fill, height, width, x, y)


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
        [ globalCss
        , model.snake
            |> toCords
            |> List.map snakeBody
            |> svg []
        ]
            |> List.map toUnstyled
    }


globalCss =
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


snakeBody : Point -> Svg.Styled.Svg msg
snakeBody ( xPos, yPos ) =
    rect
        [ width "25"
        , height "25"
        , x <| String.fromFloat <| toFloat xPos * 25
        , y <| String.fromFloat <| toFloat yPos * 25
        , fill "rgb(0, 200, 0)"
        , class "snake-body"
        , css
            [ animationDelay <| ms <| toFloat xPos * 20 ]
        ]
        []
