# 13 · Dot Product Probe

A dot product is a compressed representation of a direction relationship. Normalized vectors give 1 when aligned, 0 when perpendicular, and -1 when opposed. Displaying it as grayscale builds intuition faster than memorizing the formula.

## Task

Normalize `probe_direction`, take its dot product with `NORMAL`, map the result from -1 through 1 to 0 through 1, and display it as grayscale.

## Acceptance

- Regions facing the probe direction are close to white.
- Regions facing away are close to black.
- Perpendicular regions are middle gray instead of being clamped to black.

## Hint 1

Do not use `max(..., 0.0)` in this exercise; otherwise the negative half disappears.

## Hint 2

The mapping is still multiply by 0.5, then add 0.5.

## Hint 3

Use `float signal = dot(NORMAL, normalize(probe_direction)) * 0.5 + 0.5;`.
