# 17 · Anisotropic Highlights

An ordinary highlight is approximately symmetric around the normal. Brushed metal and hair have a clear texture direction, so their highlights stretch along the tangent or bitangent.

## Task

Pass the fragment-stage tangent and bitangent into the lighting stage. Project the halfway vector onto both directions and use `tangent_sharpness` and `binormal_sharpness` to control the stretch.

## Acceptance

- Swapping the two sharpness values rotates the highlight direction by about 90°.
- The highlight is still limited by how directly the normal faces the light.
- Tangent and bitangent are normalized before use.

## Fixed numeric targets

`base_color` defaults to `vec4(0.32, 0.12, 0.055, 1.0)`, `ROUGHNESS` stays fixed at `0.35`, and `tangent_sharpness` and `binormal_sharpness` default to `8.0` and `42.0`.

## Hint 1

You need the halfway vector `normalize(LIGHT + VIEW)`.

## Hint 2

Squaring the two directional projections works well for an elliptical exponent.

## Hint 3

Use `exp(-tangent_term - binormal_term)` to produce a smooth highlight.
