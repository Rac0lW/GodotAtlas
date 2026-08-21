# 02 · Uniform Console

Hard-coded values can only be adjusted by editing source. A `uniform` exposes a parameter to the material and Workshop, which is useful for art direction, animation, and reuse.

## Task

Declare a `vec4` color uniform named `ink_color` and use it to fill the preview. Set its default to `vec4(0.12, 0.78, 0.72, 1.0)`.

## Acceptance

- Workshop recognizes `ink_color`.
- The preview updates immediately when the color control changes.
- The Shader no longer uses a hard-coded final color.

## Hint 1

The color parameter can use the `source_color` hint.

## Hint 2

Declare it outside functions: `uniform vec4 ... : source_color = ...;`.

## Hint 3

Assign `ink_color` directly to `COLOR` inside `fragment()`.
