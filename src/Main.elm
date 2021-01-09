module Main exposing (main)

import Browser exposing (document)
import Color
import Css.Transitions exposing (transition)
import TypedSvg exposing (rect, svg)
import TypedSvg.Attributes exposing (fill)
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
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


view =
    { title = "Juice Snake"
    , body = [ svg [] [ snakeBody 0 0 ] ]
    }


snakeBody xPos yPos =
    rect
        [ width 25
        , height 25
        , x <| xPos * 25
        , y <| yPos * 25
        , fill <| Paint Color.green
        ]
        []
