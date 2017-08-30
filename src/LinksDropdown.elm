module LinksDropdown
    exposing
        ( Item
        , LinksDropdown
        , Msg
        , Settings
        , defaultSettings
        , init
        , initWithSettings
        , update
        , view
        )

{-| Creates a dropdown of items that contain links to other pages: clicking on one of the items will open its link in a new tab.


# Types

@docs LinksDropdown, Item, Msg, Settings


# Functions

@docs defaultSettings, init, initWithSettings, update, view

-}

import Html exposing (Html, a, button, div, li, span, text, ul)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onBlur, onClick)


{-|

@docs Opaque type representing messages used to change internal state.

-}
type Msg
    = Toggle State


{-|

@docs The LinksDropdown (opaque) model.

-}
type LinksDropdown
    = LinksDropdown Model


{-|

@docs A dropdown item.

-}
type alias Item =
    { url : String
    , label : String
    }


{-|

@docs Customization settings.

-}
type alias Settings =
    { placeHolder : String
    , closedClass : String
    , openedClass : String
    , menuClass : String
    , buttonClass : String
    , arrowUpClass : String
    , arrowDownClass : String
    , itemClass : String
    }


{-| Internal state.
-}
type State
    = Opened
    | Closed


{-| Internal model.
-}
type alias Model =
    { settings : Settings
    , state : State
    }


{-|

@docs Initialize a LinksDropdown with default settings.

-}
init : LinksDropdown
init =
    LinksDropdown
        { settings = defaultSettings
        , state = Closed
        }


{-|

@docs Initialize a LinksDropdown with custom settings.

-}
initWithSettings : Settings -> LinksDropdown
initWithSettings settings =
    LinksDropdown
        { settings = settings
        , state = Closed
        }


{-|

@docs Default look and feel settings.

-}
defaultSettings : Settings
defaultSettings =
    { placeHolder = "Select ..."
    , closedClass = "dropdown"
    , openedClass = "dropdown open"
    , menuClass = "dropdown-menu"
    , buttonClass = "button-as-dropdown dropdown-toggle form-control"
    , arrowUpClass = "arrow glyphicon glyphicon-triangle-top"
    , arrowDownClass = "arrow glyphicon glyphicon-triangle-bottom"
    , itemClass = ""
    }


{-|

@docs Update a LinksDropdown. Returns the updated LinksDropdown and an Event
that communicates changes that are relevant to the outside world, if
any (e.g. item selection).

-}
update : Msg -> LinksDropdown -> LinksDropdown
update msg (LinksDropdown model) =
    case msg of
        Toggle state ->
            LinksDropdown { model | state = state }


{-|

@docs Render a LinksDropdown using provided items, optional selected item, and
function that returns a string representation of an item.

-}
view : List Item -> LinksDropdown -> Html Msg
view links (LinksDropdown { settings, state }) =
    let
        ( clazz, newState, arrow ) =
            case state of
                Closed ->
                    ( settings.closedClass, Opened, settings.arrowDownClass )

                Opened ->
                    ( settings.openedClass, Closed, settings.arrowUpClass )

        menuItems =
            List.map
                (viewLink settings.itemClass)
                links
    in
    div
        [ class clazz ]
        [ button
            [ class settings.buttonClass
            , onClick (Toggle newState)
            , onBlur (Toggle Closed)
            ]
            [ text settings.placeHolder
            , span [ class arrow ] []
            ]
        , ul
            [ class settings.menuClass ]
            menuItems
        ]


viewLink : String -> Item -> Html msg
viewLink itemClass { url, label } =
    li
        [ class itemClass ]
        [ a
            [ href url
            , target "_blank"
            ]
            [ text label ]
        ]
