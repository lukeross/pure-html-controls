# Pure HTML Controls

Experimental widget/control set using pure HTML and CSS

## `form`

Binds `<form>` to CSS classes used for validation

## `form-text`

An HTML text input

- `placeholder="text"` - placeholder text to use
- `pattern="regexp"` - validation pattern to
- `required="required"` - whether element is required
- `<lr:label>` - label to display, default none
- `<lr:error-message>` - error to display when validation fails

## `form-submit`

A submit button, which disables itself until the form is valid