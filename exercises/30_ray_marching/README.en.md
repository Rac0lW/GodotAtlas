# 30 · Ray Marching

Ray marching sends a ray from the camera and advances by the estimated distance to the nearest surface at each step. A sufficiently small distance is a hit; exceeding the total distance means there is no object.

## Task

Implement a sphere SDF and a loop of at most 64 steps. Shade a hit using surface depth and a simple normal estimate; output a background color on a miss.

## Acceptance

- The center contains a volumetric-looking sphere rather than a 2D circle.
- The sphere edge is stable and does not mark the whole screen as a hit.
- The loop has both a hit threshold and a maximum-distance exit condition.

## Fixed numeric targets

The miss background interpolates from `vec3(0.015, 0.028, 0.055)` to `vec3(0.05, 0.12, 0.16)`. A hit uses `vec3(0.06, 0.42, 0.48)` for diffuse color and `vec3(0.95, 0.48, 0.14)` for rim light, with Alpha fixed at `1.0`.

## Hint 1

The sphere distance is `length(point) - radius`.

## Hint 2

Build and normalize the ray direction from centered UV and a fixed Z component.

## Hint 3

Estimate the SDF gradient with finite differences in X, Y, and Z; that gradient is the surface normal.
