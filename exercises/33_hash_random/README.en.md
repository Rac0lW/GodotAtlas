# 33 · Reproducible Randomness

Procedural textures need a sense of randomness, but every pixel must get a stable result. Quantize UV into a grid first, then use a hash function to map each grid coordinate to 0 through 1.

## Task

Implement `hash21(vec2)`, sample `floor(UV * 12.0)`, and output the result as grayscale.

## Acceptance

- The image is made of stable light-and-dark cells.
- The same grid position returns the same value on different frames.
- The random value comes from UV and does not depend on an extra texture.

## Hint 1

Use `fract` and a large constant to scramble the input coordinate first.

## Hint 2

`dot` can combine the two components into a new scalar.

## Hint 3

`float value = hash21(floor(UV * 12.0));` takes one value from each grid cell.
