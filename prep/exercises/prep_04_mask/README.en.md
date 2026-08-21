# P04 · Make a Soft Edge

`smoothstep` smoothly clamps a value in a range to `0` through `1`. Used as a mask, it creates a transition without a hard edge.

## Task

Make the left side of the image black and the right side white, with a smooth `smoothstep` transition in between.

## Acceptance

- The left side is close to black and the right side is close to white.
- The transition is continuous without a sudden jump.

## Hint 1

Use `UV.x` as the input.

## Hint 2

`smoothstep(edge0, edge1, value)` returns a value from `0` to `1`.

## Hint 3

Copy the mask into all three RGB channels with `vec3(mask)`.
