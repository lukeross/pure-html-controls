# Pure HTML Controls

Experimental widget/control set using pure HTML and CSS.

You will need

- [xsltproc](https://gitlab.gnome.org/GNOME/libxslt/-/wikis/home)

There are examples in the `stories/` directory; use `make` to build them.

## `accordion`

An expand/contract section

- `<lr:accordion-label>` - the portion to always display. Can contain other tags
- `<lr:accordion-open>` - inline block to display when the accordion is open
- `<lr:accordion-closed>` - inline block to display when the accordion is closed

## `form`

Binds `<form>` to CSS classes used for validation

## `form-text`

An HTML text input

- `type="text|date|..."` - input variation to use
- `placeholder="text"` - placeholder text to use
- `pattern="regexp"` - validation pattern to
- `required="required"` - whether element is required
- `<lr:form-label>` - label to display, default none
- `<lr:form-error-message>` - error to display when validation fails

## `form-submit`

A submit button, which disables itself until the form is valid

## `tooltip-wrapper`

An on-hover tooltip

- `position="over|under"` - where to provide the tooltip, relative to container
- `<lr:tooltip>` - the tooltip contents to show on over
