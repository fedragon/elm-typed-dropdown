# elm-dropdowns

This library provides ready-made dropdowns for specific use cases, namely:

- LinksDropdown: a dropdown of links that open in a new tab.
- TypedDropdown: a dropdown that can deal with items of any arbitrary type `t`. Items are not part of this component's internal model, meaning that there is a single source of truth: your own `Model`. It sets the selected item by value, rather than by index, which can be useful when the set of items is dynamic. User selection is communicated by returning an `Event` that contains the whole selected item. 

## Usage

See `examples` folder for complete usage examples. You can find the minimal set of styles that should be applied to the dropdown in provided `dropdown.css`.

## Credits

This library's design was deeply influenced by Evan Czaplicki's [About API Design](https://github.com/evancz/elm-sortable-table#about-api-design) and [elm-datepicker](https://github.com/elm-community/elm-datepicker).
