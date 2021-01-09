module Main exposing (main)

import Browser exposing (document)
import Color
import Css exposing (animationDuration, animationName, ms, sec)
import Css.Animations exposing (custom, keyframes, property)
import Css.Global exposing (global)
import Css.Transitions exposing (transition)
import Html.Styled exposing (toUnstyled)
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
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


view =
    { title = "Juice Snake"
    , body =
        [ toUnstyled css
        , svg [] [ snakeBody 0 0 ]
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
        ]


snakeBody xPos yPos =
    rect
        [ width 25
        , height 25
        , x <| xPos * 25
        , y <| yPos * 25
        , fill <| Paint Color.green
        , class [ "snake-body" ]
        ]
        []
