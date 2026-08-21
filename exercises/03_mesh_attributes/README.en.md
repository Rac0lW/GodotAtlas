# 03 · See Mesh Attributes

A 3D mesh carries more than shape: it also carries position, normal, UV, tangent, and other attributes. Normal components range from -1 to 1 while color components range from 0 to 1, so remap the former before displaying it.

## Task

Map the view-space normal `NORMAL` from `[-1, 1]` to `[0, 1]` and write it to `ALBEDO`. Keep the material `unshaded` so lighting does not affect the result.

## Acceptance

- Different sphere orientations show different RGB colors.
- The color is continuous and has no UV seam.
- Rotating the preview camera changes the color with the view-space direction.

## Hint 1

An interval remap can be written as a multiply followed by an offset.

## Hint 2

`[-1, 1] * 0.5 + 0.5` produces `[0, 1]`.

## Hint 3

Use `ALBEDO = NORMAL * 0.5 + 0.5;`.
