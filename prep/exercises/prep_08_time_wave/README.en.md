# P08 · Animate the Pattern

`TIME` is a continuous time signal provided by Godot. Combined with `sin`, it produces repeatable periodic animation without jumps.

## Task

Use `sin(UV.x * 6.283 + TIME)` to create a horizontal wave, map it to `0` through `1`, and keep the green channel showing `UV.y`.

## Acceptance

- A continuous light-and-dark wave appears from left to right.
- The wave moves smoothly over time instead of jumping randomly.
- The green channel still shows the top-to-bottom UV gradient.

## Hint 1

The range of `sin` is `-1` to `1`.

## Hint 2

Use `0.5 + 0.5 * sin(...)` to map it to `0` through `1`.

## Hint 3

Put the wave into `vec4(wave, UV.y, 0.2, 1.0)`.
