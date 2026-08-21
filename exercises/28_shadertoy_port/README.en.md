# 28 · Shadertoy Port

Shadertoy commonly uses pixel coordinates with the origin at the lower-left, while Godot CanvasItem usually starts from normalized UV. A port should first unify origin, range, aspect ratio, and time instead of mechanically renaming variables.

## Task

Map UV to a zero-centered -1 through 1 space, correct the X axis with `viewport_size`, and use `TIME` to drive three moving wave sources.

## Acceptance

- Changing the preview aspect ratio does not turn circles into ellipses.
- The pattern moves continuously over time.
- Coordinate conversion is concentrated at the beginning; later formulas do not correct it again.

## Fixed numeric targets

Mix the color from `vec3(0.025, 0.045, 0.085)` to `vec3(0.12, 0.86, 0.72)`, then mix high-signal regions with `vec3(0.98, 0.46, 0.14)`. Alpha is fixed at `1.0`, and `viewport_size` defaults to `vec2(640.0, 360.0)`.

## Hint 1

Centered coordinates are `UV * 2.0 - 1.0`.

## Hint 2

Multiply the X component by `viewport_size.x / viewport_size.y`.

## Hint 3

Add three `sin()` waves with different frequencies and directions, then map the result into color.
