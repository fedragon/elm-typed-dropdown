[![Elm package](https://img.shields.io/elm-package/v/fedragon/elm-typed-dropdown.svg)](https://github.com/fedragon/elm-typed-dropdown/releases)

# elm-typed-dropdown

This library provides a dropdown that can deal with items of any arbitrary type `t`. Items are not part of this component's internal model, meaning that there is a single source of truth: your own `Model`.

It sets the selected item by value, rather than by index, which can be useful when the set of items is dynamic. User selection is communicated by returning an `Event` that contains the whole selected item. 

## Features

- Items can be of any type `t`
- Items are not part of internal component model
- Item selected by value, rather than by index
- User selection communicated via `Event`
- Styles can be customized by providing `Settings`

## Usage

```elm
import Dropdown exposing (Dropdown, Event(ItemSelected))

-- type of items in this dropdown
type alias Country =
    { code : String
    , name : String
    }


type alias Model =
    { dropdown : Dropdown
    , items : List Country -- items that will be shown in dropdown
    , selectedItem : Maybe Country -- selected item, if any
    , ...
    }


type Msg
    = CountrySelected (Dropdown.Msg Country)
    | ...


init =
    Model
        Dropdown.init
        [ Country "ALB" "Albania"
        , Country "ITA" "Italy"
        , Country "NLD" "Netherlands"
        ]
        Nothing
        ...


update msg model =
    case msg of
        CountrySelected dropdownMsg ->
            let
                ( updatedDropdown, event ) =
                    Dropdown.update dropdownMsg model.dropdown
            in
                case event of
                    ItemSelected country ->
                        { model
                            | dropdown = updatedDropdown
                            , selectedItem = Just country
                        }

                    _ ->
                        { model | dropdown = updatedDropdown }
        ...


view model =
    ...
        , div []
            [ Html.map CountrySelected <|
                Dropdown.view
                    model.items
                    model.selectedItem
                    .name
                    model.dropdown
            ]
        ]
```

Have a look at the `examples` folder to get a running example.

### A note about CSS styles

The default style classes are based on [Bootstrap 3.3.7]("https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"), with some minor additions included in `dropdown.css`: both be imported in your HTML **separately** (if you'd rather import them directly in your Elm code, I suggest you to have a look at https://github.com/massung/elm-css and see how it can be done in `Example.elm`). 
If you'd rather use different classes or change style altogether, you can provide your own `Settings` by using `Dropdown.initWithSettings` instead of `Dropdown.init`.

## Credits

This library's design was deeply influenced by Evan Czaplicki's [About API Design](https://github.com/evancz/elm-sortable-table#about-api-design) and [elm-datepicker](https://github.com/elm-community/elm-datepicker).
