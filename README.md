# elm-typed-dropdown

This library provides a dropdown that can deal with items of any arbitrary type `t`. Items are not part of this component's internal model, meaning that there is a single source of truth: your own `Model`.

It sets the selected item by value, rather than by index, which can be useful when the set of items is dynamic. User selection is communicated by returning an `Event` that contains the whole selected item. 

## Features

- Items can be of any type `t`
- Items not part of internal model
- Item selected by value, rather than by index
- User selection communicated via events

## Usage

See `examples` folder for complete usage examples.

## Credits

This library's design was deeply influenced by Evan Czaplicki's [About API Design](https://github.com/evancz/elm-sortable-table#about-api-design) and [elm-datepicker](https://github.com/elm-community/elm-datepicker).