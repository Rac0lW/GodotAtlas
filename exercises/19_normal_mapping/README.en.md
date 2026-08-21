# 19 · Procedural Normals

The RGB channels of a normal map encode a tangent-space direction. This exercise creates the same kind of data from UV instead of an image, separating sampling from space conversion.

## Task

Use sine waves of UV to generate an XY perturbation, reconstruct a valid Z component, build TBN, transform the result, and write it to `NORMAL`.

## Acceptance

- `frequency` controls the ripple density.
- When `normal_strength` is zero, the original geometric normal returns.
- At high strength the normal remains unit length and contains no NaN.

## Fixed numeric targets

Interpolate the base color from `vec3(0.04, 0.18, 0.2)` to `vec3(0.12, 0.72, 0.64)`. The default values of `frequency` and `normal_strength` are `28.0` and `0.38`; keep `ROUGHNESS` fixed at `0.38`.

## Hint 1

Clamp the squared XY length so it remains below 1.

## Hint 2

Reconstruct Z with `sqrt(1.0 - dot(xy, xy))`.

## Hint 3

Still use `mat3(TANGENT, BINORMAL, NORMAL)` for the final conversion.
