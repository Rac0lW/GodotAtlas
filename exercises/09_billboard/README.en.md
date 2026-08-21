# 09 · Billboard

A billboard is a plane that always faces the camera. The key is not rotating a node every frame, but rebuilding its model orientation from the inverse view matrix while keeping its translation.

## Task

Enable `skip_vertex_transform`, use the first three basis vectors of `INV_VIEW_MATRIX` and `MODEL_MATRIX[3]` to construct a billboard matrix, and write `POSITION` manually.

## Acceptance

- The plane always faces the camera when the preview camera rotates.
- The plane keeps its world position.
- Vertices pass through world, view, and projection stages.

## Fixed numeric targets

Keep `ALBEDO = vec3(0.95, 0.55, 0.16)` in the fragment stage. This is the fixed visual target for the billboard exercise and cannot be replaced with a subjective color name.

## Hint 1

The first three columns of the new matrix control orientation; the fourth controls translation.

## Hint 2

The projection chain goes from world position to view position and then to clip position.

## Hint 3

Finally write `POSITION = PROJECTION_MATRIX * VIEW_MATRIX * vertex_ws;`.
