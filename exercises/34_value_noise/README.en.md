# 34 · Value Noise

Random cells create hard blocks. Value Noise takes random values from four neighboring corners and interpolates them with smooth weights, creating a continuous transition between cells.

## Task

Implement 2D Value Noise on an 8 × 8 grid. Shape the local coordinate with `smoothstep` and use two `mix` operations to interpolate the four corner values.

## Acceptance

- The image is continuous cloudy grayscale rather than separate blocks.
- Increasing or decreasing grid frequency keeps the texture continuous.
- All four corner values come from the same hash function.

## Hint 1

`floor(p)` gives the current grid cell and `fract(p)` gives the local coordinate.

## Hint 2

The smooth weight can be `local * local * (3.0 - 2.0 * local)`.

## Hint 3

Interpolate twice along X, then once along Y.
