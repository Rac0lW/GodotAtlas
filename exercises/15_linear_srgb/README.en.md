# 15 · Linear Light and sRGB

Lighting calculations should happen in linear space, while display devices usually use approximate sRGB encoding. Showing the same linear number directly looks dark; encoding it better matches human brightness perception.

## Task

Show a linear gradient in the upper half and a gradient encoded with approximate gamma `1.0 / 2.2` in the lower half so their brightness responses can be compared directly.

## Acceptance

- The left and right endpoints match between the two halves.
- The middle brightness is visibly different.
- The lower half uses `pow()` rather than simply adding brightness.

## Hint 1

Use `UV.x` as the gradient value.

## Hint 2

The encoding expression is `pow(linear_value, 1.0 / 2.2)`.

## Hint 3

Use `step(0.5, UV.y)` to choose the upper or lower half.
