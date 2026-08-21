# 20 · SDF Primitives

A signed distance field represents the distance from a point to a boundary: negative inside the shape and positive outside. `min()` acts like a union, so complex graphics can be assembled from simple functions.

## Task

Implement circle and rectangle distance functions, combine them with `min()`, and use a narrow `smoothstep()` to create an anti-aliased mask.

## Acceptance

- The image contains both a circle and a rectangle as one connected shape.
- The edge is smooth rather than hard and jagged.
- Moving either primitive still preserves the union relationship.

## Fixed numeric targets

The outside color is `vec3(0.035, 0.055, 0.09)`, the inside color is `vec3(0.96, 0.52, 0.16)`, and Alpha is fixed at `1.0`.

## Hint 1

The circle distance is `length(p) - radius`.

## Hint 2

For a rectangle, start with `abs(p) - half_size`, then handle outside and inside distance.

## Hint 3

Use `min(circle_distance, box_distance)` for the union distance.
