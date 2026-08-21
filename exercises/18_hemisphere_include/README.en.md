# 18 · Hemisphere Light and ShaderInclude

Hemisphere lighting interpolates between a sky color and ground-reflection color according to how upward-facing the normal is. Extracting the calculation into `.gdshaderinc` lets multiple materials share and independently review the same function.

## Task

Include `res://shared/shaders/atlas_lighting.gdshaderinc`, call `atlas_hemisphere()` to calculate the environment color, and multiply it by `base_color`.

## Acceptance

- The Shader uses `#include` instead of copying the function implementation.
- Upward-facing regions lean toward the sky color and downward regions toward the ground color.
- The base color still affects the final result.

## Fixed numeric targets

`base_color` defaults to `vec4(0.82, 0.74, 0.58, 1.0)`, `sky_color` defaults to `vec4(0.18, 0.52, 0.92, 1.0)`, and `ground_color` defaults to `vec4(0.36, 0.12, 0.055, 1.0)`.

## Hint 1

The include directive belongs outside functions.

## Hint 2

The function arguments are normal, sky color, and ground color in that order.

## Hint 3

Multiply the return value by `base_color.rgb` and write it to `ALBEDO`.
