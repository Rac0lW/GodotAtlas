# 12 · Lambert

Lambert diffuse lighting only cares about the angle between the surface normal and incoming light direction. A larger dot product means the surface faces the light more directly; negative values mean the light is behind the surface and should be clamped to zero.

## Task

Disable built-in diffuse lighting. In `light()`, compute `max(dot(NORMAL, LIGHT), 0.0)`, multiply by material color, light color, and attenuation, then add it to `DIFFUSE_LIGHT`.

## Acceptance

- Back-facing surfaces never receive negative brightness.
- Moving the light moves the light-dark boundary smoothly.
- Light color and distance attenuation still work.

## Fixed numeric targets

`base_color` defaults to `vec4(0.78, 0.34, 0.12, 1.0)`. The preview fixture supplies the light color; the material base color must use this numeric value.

## Hint 1

After defining a custom `light()`, you must accumulate the lighting result yourself.

## Hint 2

The attenuation variable is `ATTENUATION`.

## Hint 3

The final form is `DIFFUSE_LIGHT += ALBEDO * LIGHT_COLOR * ndotl * ATTENUATION;`.
