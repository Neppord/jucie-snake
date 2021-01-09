module Main exposing (main)

import Browser exposing (document)
import Browser.Events exposing (onKeyDown, onKeyPress)
import Css exposing (animationDelay, animationDuration, animationName, ms, vmin)
import Css.Animations exposing (keyframes, property)
import Css.Global exposing (global)
import Html.Styled exposing (toUnstyled)
import Json.Decode exposing (field, string, succeed)
import List.Extra
import Svg.Styled exposing (rect, svg)
import Svg.Styled.Attributes exposing (class, css, fill, height, width, x, y)
import Time exposing (every)


main =
    document
        { init = init
        , view = view
        , update = update
        , subscriptions =
            [ Tick
                |> always
                |> every 100
            , field "key" string
                |> Json.Decode.map (keyToDirection >> Turn)
                |> onKeyDown
            ]
                |> Sub.batch
                |> always
        }


keyToDirection key =
    case key of
        "ArrowUp" ->
            Up

        "ArrowDown" ->
            Down

        "ArrowLeft" ->
            Left

        "ArrowRight" ->
            Right

        _ ->
            Down


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( case msg of
        Tick ->
            model
                |> grow
                |> shrink

        Turn direction ->
            turn direction model
    , Cmd.none
    )


turn direction model =
    { model
        | direction = direction
    }


grow model =
    { model
        | snake =
            { head = move model.direction model.snake.head
            , tail = flip model.direction :: model.snake.tail
            }
    }


shrink model =
    { model
        | snake =
            { head = model.snake.head
            , tail = List.take (List.length model.snake.tail - 1) model.snake.tail
            }
    }


init : () -> ( Model, Cmd msg )
init () =
    ( { snake =
            { head = ( 5, 5 )
            , tail = [ Right, Right, Right, Right, Down, Down, Left ]
            }
      , direction = Left
      }
    , Cmd.none
    )


flip : Direction -> Direction
flip direction =
    case direction of
        Up ->
            Down

        Down ->
            Up

        Left ->
            Right

        Right ->
            Left


type Msg
    = Tick
    | Turn Direction


type alias Model =
    { snake : Snake
    , direction : Direction
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


view model =
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
            , Css.property
                "animation-timing-function"
                "cubic-bezier(.35,.9,.94,1.19)"
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
