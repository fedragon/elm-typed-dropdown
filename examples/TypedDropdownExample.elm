module Example exposing (..)

import Css
import Html exposing (Html, div, h1, h3, text)
import Html.Attributes exposing (class)
import TypedDropdown exposing (Event(ItemSelected), TypedDropdown)


type alias Country =
    { code : String
    , name : String
    }


type alias Model =
    { dropdown : TypedDropdown
    , countries : List Country
    , selectedCountry : Maybe Country
    }


type Msg
    = CountrySelected (TypedDropdown.Msg Country)


init : Model
init =
    Model
        TypedDropdown.init
        [ Country "ALB" "Albania"
        , Country "ITA" "Italy"
        , Country "NLD" "Netherlands"
        ]
        Nothing


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
        CountrySelected dropdownMsg ->
            let
                ( updatedDropdown, event ) =
                    TypedDropdown.update dropdownMsg model.dropdown
            in
            case event of
                ItemSelected country ->
                    { model
                        | dropdown = updatedDropdown
                        , selectedCountry = Just country
                    }

                _ ->
                    { model | dropdown = updatedDropdown }


view : Model -> Html Msg
view model =
    let
        imports =
            [ "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
            , "dropdown.css"
            ]

        stylesheet =
            Css.stylesheet imports []

        countryToString country =
            "Country { code = "
                ++ country.code
                ++ ", name = "
                ++ country.name
                ++ " }"

        selected =
            Maybe.map
                countryToString
                model.selectedCountry
                |> Maybe.withDefault "-"
    in
    div [ class "col-md-9 col-lg-9" ]
        [ h1 [] [ text "Select a country" ]
        , h3 [] [ text ("Selected: " ++ selected) ]
        , div [ class "col-md-3 col-lg-3" ]
            [ Css.style [ Html.Attributes.scoped True ] stylesheet
            , Html.map CountrySelected <|
                TypedDropdown.view
                    model.countries
                    model.selectedCountry
                    .name
                    model.dropdown
            ]
        ]
