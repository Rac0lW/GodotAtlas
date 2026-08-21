# 08 · Mix, Mask, and Alpha

A hard threshold creates aliasing and flicker. A distance field combined with `smoothstep()` turns the boundary into a controllable transition that can drive both color and transparency.

## Task

Build a radius mask centered in the image, use `feather` to control the soft edge, mix `outside_color` and `inside_color`, and write the mask into Alpha.

## Acceptance

- The circle interior is opaque and the exterior is transparent.
- Increasing `feather` makes the edge wider.
- Color and Alpha use the same mask.

## Fixed numeric targets

`inside_color` defaults to `vec4(0.95, 0.58, 0.18, 1.0)` and `outside_color` defaults to `vec4(0.05, 0.11, 0.18, 1.0)`. The default values of `radius` and `feather` are `0.32` and `0.035`.

## Hint 1

Centered coordinates are `UV - vec2(0.5)`.

## Hint 2

Use `length()` for the distance.

## Hint 3

The mask can be `1.0 - smoothstep(radius - feather, radius + feather, distance)`.
