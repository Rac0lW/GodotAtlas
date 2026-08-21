# P01 · Light Up a Pixel

A Shader computes one result for every pixel on screen. Before learning coordinates, write a fixed color to `COLOR` and confirm that the code, preview, and validation workflow all work.

## Task

Output the target RGBA value `vec4(0.12, 0.78, 0.72, 1.0)`.

Each component is in the range `0.0` to `1.0`, which is approximately `RGB(31, 199, 184)` and Alpha `255` when converted to 8-bit channels. The numeric target is more precise than the name “teal”.

## Acceptance

- The target `COLOR` is `vec4(0.12, 0.78, 0.72, 1.0)`.
- Alpha is `1.0`, so the image is fully opaque.
- The validator compares numeric render error against the target instead of comparing a color name.

## Hint 1

Write the fragment-stage code inside `fragment()`.

## Hint 2

Use `vec4(r, g, b, a)` to represent a color.

## Hint 3

Assign the final color to `COLOR`.
