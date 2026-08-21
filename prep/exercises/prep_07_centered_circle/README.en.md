# P07 · Centered Coordinates and a Circle

The UV origin is near the upper-left. Subtracting `vec2(0.5)` makes the image center the new origin, which makes distance-based circles easier to express.

## Task

Use `length(UV - vec2(0.5))` to calculate distance from the center, then use `smoothstep` to create a white circle with a radius of about `0.23`.

## Acceptance

- The circle is centered in the preview.
- The inside is close to white and the outside is close to black.
- The circle has a narrow, continuous transition band.

## Hint 1

First declare `vec2 centered = UV - vec2(0.5);`.

## Hint 2

`length(centered)` is the distance from a pixel to the center.

## Hint 3

Use `1.0 - smoothstep(0.22, 0.24, distance)` to create a mask that is `1` inside the circle.
