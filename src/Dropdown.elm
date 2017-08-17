module Dropdown
    exposing
        ( init
        , update
        , view
        , Dropdown
        , Event(..)
        , Msg
        )

{-| This library provides a dropdown that can deal with items of any type `t`.
Items are not part of this component's internal model, meaning that there is a
single source of truth: your own `Model`.
It sets the selected item by value, rather than by index, which can be useful
when the set of items is dynamic. User selection is communicated by returning
an Event that contains the selected item.


# Types

@docs Dropdown, Event, Msg


# Functions

@docs init, update, view

-}

import Html exposing (Html, a, button, div, li, span, text, ul)
import Html.Attributes exposing (class)
import Html.Events exposing (onBlur, onClick, onWithOptions)
import Json.Decode
import Maybe.Extra


{-| Internal state.
-}
type State
    = Opened
    | Closed


{-| @docs Opaque type representing messages used to change internal state.
-}
type Msg t
    = Toggle State
    | Select t


{-| @docs Events that are used to communicate changes in state relevant to
users of this component.
-}
type Event t
    = Unchanged
    | ItemSelected t


{-| Internal model.
-}
type alias Model =
    { state : State }


{-| @docs The Dropdown (opaque) model.
-}
type Dropdown
    = Dropdown Model


{-| @docs Initialize a Dropdown.
-}
init : Dropdown
init =
    Dropdown { state = Closed }


{-| @docs Update a Dropdown. Returns the updated Dropdown and an Event
that communicates changes that are relevant to the outside world, if
any (e.g. item selection).
-}
update : Dropdown -> Msg t -> ( Dropdown, Event t )
update (Dropdown model) msg =
    case msg of
        Toggle state ->
            ( Dropdown { model | state = state }
            , Unchanged
            )

        Select item ->
            ( Dropdown model
            , ItemSelected item
            )


{-| @docs Render a Dropdown using provided items, optional selected item, and
function that returns a string representation of an item.
-}
view : Dropdown -> List t -> Maybe t -> (t -> String) -> Html (Msg t)
view (Dropdown model) items selectedItem descriptionOf =
    let
        ( clazz, newState, arrow ) =
            case model.state of
                Closed ->
                    ( "dropdown", Opened, "glyphicon-triangle-bottom" )

                Opened ->
                    ( "dropdown open", Closed, "glyphicon-triangle-top" )

        isActive item =
            case selectedItem of
                Just selection ->
                    selection == item

                _ ->
                    False

        menuItems =
            (List.map
                (\item ->
                    viewItem
                        item
                        descriptionOf
                        (isActive item)
                )
                items
            )
    in
        div
            [ class clazz ]
            [ button
                [ class "button-as-dropdown dropdown-toggle form-control"
                , onClick (Toggle newState)
                , onBlur (Toggle Closed)
                ]
                [ text (Maybe.Extra.unwrap "Select ..." descriptionOf selectedItem)
                , span [ class ("arrow glyphicon " ++ arrow) ] []
                ]
            , ul
                [ class "dropdown-menu"
                , onBlur (Toggle Closed)
                ]
                (menuItems)
            ]


onItem : String -> msg -> Html.Attribute msg
onItem ev =
    Json.Decode.succeed
        >> onWithOptions ev
            { preventDefault = False
            , stopPropagation = True
            }


viewItem : t -> (t -> String) -> Bool -> Html (Msg t)
viewItem item descriptionOf active =
    let
        attrs =
            if active then
                [ class "active" ]
            else
                []
    in
        li
            (attrs)
            [ a
                [ onItem "mousedown" (Select item) ]
                [ text (descriptionOf item) ]
            ]
