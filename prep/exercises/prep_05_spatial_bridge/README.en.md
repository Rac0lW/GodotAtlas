# P05 · See a 3D Object

A spatial Shader uses `ALBEDO` for an object's base color. Do not calculate lighting yet; put one simple color on the sphere as preparation for main exercise 3.

## Task

Make the sphere display `ALBEDO = vec3(0.35, 0.58, 0.76)` and keep the shader `unshaded`.

## Acceptance

- The sphere's base color is `vec3(0.35, 0.58, 0.76)`.
- The sphere remains visible while rotating the preview camera.
- The result is not affected by light and shadow.

## Hint 1

The spatial Shader type is `spatial`.

## Hint 2

`ALBEDO` accepts a `vec3` color.

## Hint 3

Write `ALBEDO = vec3(0.35, 0.58, 0.76);` in `fragment()`.
