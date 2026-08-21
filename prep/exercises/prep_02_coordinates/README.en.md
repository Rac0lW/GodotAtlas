# P02 · Read UV

`UV` is a 2D coordinate that changes from the upper-left toward the lower-right. Writing it into color makes the direction of the coordinate visible on screen.

## Task

Use `UV.x` for the red channel, `UV.y` for the green channel, and keep blue fixed at `0.35`.

## Acceptance

- The left side is darker than the right side.
- The top contains less green and the bottom contains more green.

## Fixed numeric targets

The target expression is `COLOR = vec4(UV.x, UV.y, 0.35, 1.0)`, with blue fixed at `0.35` and Alpha fixed at `1.0`.

## Hint 1

Both `UV.x` and `UV.y` range from `0` to `1`.

## Hint 2

Combine red, green, blue, and Alpha with `vec4`.

## Hint 3

The final result still goes into `COLOR`.
