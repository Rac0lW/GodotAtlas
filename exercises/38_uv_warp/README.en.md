# 38 · UV Warp

Texture distortion usually happens before sampling: modify UV first, then read the texture at the new coordinate. One image can then produce water ripples, heat haze, or lens-like distortion.

## Task

Use the screen center as the origin, generate a radial offset with `sin` and `TIME`, and sample `screen_texture` with the disturbed UV.

## Acceptance

- The original image remains recognizable while its edges bend continuously.
- The distortion changes smoothly over time without random flicker.
- Sampling still uses a valid screen texture and `SCREEN_UV`.

## Hint 1

First calculate `vec2 centered = SCREEN_UV - vec2(0.5)`.

## Hint 2

Use `length(centered)` so the offset is small at the center and larger at the edge.

## Hint 3

Add `centered * sin(radius * 18.0 - TIME * 1.5) * 0.025` back to `SCREEN_UV`.
