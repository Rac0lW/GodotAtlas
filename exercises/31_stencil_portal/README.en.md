# 31 · Stencil Portal

A stencil buffer is not a visible color image but a small integer label per pixel. The writer material marks the portal region with 1; the reader material shows the interior scene only where the stencil value equals 1.

## Task

Add stencil read mode to the reader Shader with an equal comparison and reference value 1. Keep depth writing disabled and use a procedural mesh to display the portal interior.

## Acceptance

- The interior pattern appears only where the writing geometry covered the pixels.
- The reader material does not cover pixels outside the stencil.
- When the camera moves, the mask still respects scene depth.

## Fixed numeric targets

Mix the portal interior between `vec3(0.02, 0.09, 0.12)` and `vec3(0.12, 0.88, 0.72)`. When the grid `line` is `1.0`, use the latter color.

## Hint 1

The writer Shader is at `res://shared/shaders/portal_writer.gdshader`.

## Hint 2

This exercise needs `stencil_mode read`.

## Hint 3

The complete declaration is `stencil_mode read, compare_equal, 1;`.
