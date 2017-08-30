module LinksDropdownExample exposing (..)

import Css
import Html exposing (Html, div, h1, h3, text)
import Html.Attributes exposing (class)
import LinksDropdown exposing (Item, LinksDropdown)


type alias Model =
    { dropdown : LinksDropdown
    , links : List Item
    }


type Msg
    = LinkClicked LinksDropdown.Msg


init : Model
init =
    Model
        LinksDropdown.init
        [ Item "https://duckduckgo.com" "DuckDuckGo"
        , Item "https://news.ycombinator.com" "Hacker News"
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        LinkClicked dropdownMsg ->
            { model
                | dropdown =
                    LinksDropdown.update dropdownMsg model.dropdown
            }


view : Model -> Html Msg
view model =
    let
        imports =
            [ "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
            , "dropdown.css"
            ]

        stylesheet =
            Css.stylesheet imports []
    in
    div [ class "col-md-9 col-lg-9" ]
        [ h1 [] [ text "Click one of the links" ]
        , div [ class "col-md-3 col-lg-3" ]
            [ Css.style [ Html.Attributes.scoped True ] stylesheet
            , Html.map LinkClicked <|
                LinksDropdown.view
                    model.links
                    model.dropdown
            ]
        ]
