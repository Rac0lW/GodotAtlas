# 01 · First Fragment

A fragment Shader calculates an output for every visible pixel on screen. `UV` is a 2D coordinate that changes from the upper-left toward the lower-right, and `COLOR` is the only result this exercise needs to write.

## Task

Edit `exercise.gdshader` so the red channel equals `UV.x`, the green channel equals `UV.y`, the blue channel stays at `0.35`, and Alpha stays at `1.0`.

## Acceptance

- The left side is darker and the right side is redder.
- The top contains less green and the bottom contains more green.
- The image is fully opaque.

## Hint 1

Both `UV.x` and `UV.y` range from `0` to `1`.

## Hint 2

Assemble the final color with `vec4(r, g, b, a)`.

## Hint 3

The final expression has the form `COLOR = vec4(UV.x, UV.y, 0.35, 1.0);`.
