# 04 · Coordinate Spaces

`VERTEX` is in object space by default. Moving a model does not change its object-space values; multiplying by `MODEL_MATRIX` produces world-space position, allowing color to stay fixed in the scene.

## Task

Compute world-space position in the vertex stage, pass it to the fragment stage through a varying, then scale, offset, and display its three components with `fract()` as repeating color bands.

## Acceptance

- The color comes from world position rather than UV.
- When the preview model moves, the bands stay in the world and appear to pass through it.
- The varying uses `vec3`.

## Hint 1

Position vectors need the homogeneous component `1.0` when multiplied by a matrix.

## Hint 2

World position is `(MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz`.

## Hint 3

The fragment color can be `fract(position_ws * 0.25 + 0.5)`.
