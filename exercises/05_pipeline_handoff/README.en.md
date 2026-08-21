# 05 · Pipeline Handoff

The vertex stage runs once per vertex and the fragment stage runs once per pixel. A `varying` interpolates vertex output and passes it to the fragment stage as an explicit interface between them.

## Task

Write object-space height into `vertex_height` in `vertex()`, then use it in `fragment()` to create a two-color cool-to-warm gradient.

## Acceptance

- `vertex_height` is assigned in the vertex stage.
- The fragment stage uses the interpolated value.
- The plane changes continuously along its height instead of showing one color per triangle.

## Fixed numeric targets

The cool endpoint is `vec3(0.08, 0.18, 0.32)` and the warm endpoint is `vec3(0.95, 0.48, 0.18)`. At `vertex_height = -0.5`, the result should be close to the cool endpoint; at `vertex_height = 0.5`, it should be close to the warm endpoint.

## Hint 1

This exercise only needs to pass one `float`.

## Hint 2

The height comes from `VERTEX.y`.

## Hint 3

Use `smoothstep(-0.5, 0.5, vertex_height)` as the blend factor, then mix the colors with `mix()`.
