# P09 · Hand the Color to a Parameter

A `uniform` in a Shader is an editable material input. Moving the color out of the function body lets the preview and a production project share the same parameter workflow.

## Task

Declare `uniform vec4 prep_color` with the default value `vec4(0.12, 0.78, 0.72, 1.0)`, then output it to `COLOR`.

## Acceptance

- The file contains a `vec4` uniform named `prep_color`.
- The default image is teal with RGB `(0.12, 0.78, 0.72)` and Alpha `1.0`.
- Changing the material parameter changes the image through the uniform.

## Hint 1

The declaration form is `uniform vec4 prep_color : source_color = ...;`.

## Hint 2

The uniform's default value is still a constant inside the Shader.

## Hint 3

Write `COLOR = prep_color;` in `fragment()`.
