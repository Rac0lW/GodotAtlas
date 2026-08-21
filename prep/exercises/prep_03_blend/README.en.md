# P03 · Blend Two Colors

`mix(a, b, amount)` transitions smoothly between two values according to `amount`. It is a common building block for gradients and material changes.

## Task

Use `UV.x` to create a horizontal gradient between `vec3(0.88, 0.34, 0.15)` and `vec3(0.12, 0.78, 0.72)`. Use the first color at the left edge and the second at the right edge.

## Acceptance

- At `UV.x = 0.0`, the result is close to `vec3(0.88, 0.34, 0.15)`.
- At `UV.x = 1.0`, the result is close to `vec3(0.12, 0.78, 0.72)`.
- The middle transitions smoothly without an obvious band.

## Hint 1

`UV.x` can be the third argument to `mix`.

## Hint 2

Mix the `vec3` colors first, then add Alpha.

## Hint 3

The target shape is `vec4(mix(color_a, color_b, UV.x), 1.0)`.
