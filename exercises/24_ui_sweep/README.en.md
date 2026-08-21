# 24 · UI Sweep

A sweep is usually made from a moving narrow band, soft edges, and a response from the underlying image. Pure white layered on top looks like a sticker; modulating the highlight with the base pattern feels more like material reflection.

## Task

Generate a dark grid background, build a diagonal narrow band that moves from lower-left to upper-right over time, and multiply the highlight strength by the background brightness.

## Acceptance

- The highlight loops along the diagonal.
- `sweep_width` controls the band width.
- Highlights are weaker over the dark grid areas.

## Fixed numeric targets

`accent` defaults to `vec4(0.96, 0.62, 0.18, 1.0)`. The grid base color mixes between `vec3(0.035, 0.055, 0.09)` and `vec3(0.08, 0.12, 0.17)`. The default values of `sweep_speed` and `sweep_width` are `0.35` and `0.08`.

## Hint 1

Use `UV.x + UV.y` as the diagonal coordinate.

## Hint 2

The looping position is `fract(TIME * speed)`.

## Hint 3

Build the narrow band with `1.0 - smoothstep(width, width * 2.0, abs(diagonal - position))`.
