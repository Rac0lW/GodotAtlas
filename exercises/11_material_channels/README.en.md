# 11 · Material Channels

Lighting depends not only on the lights but also on how the material responds to energy. `ALBEDO` defines base reflectance color, `ROUGHNESS` controls highlight width, and `METALLIC` moves a material toward an insulator or a metal.

## Task

Declare `base_color`, `roughness_value`, and `metallic_value` as uniforms, then write them into their corresponding material channels.

## Acceptance

- All three parameters appear in the Workshop controls.
- As roughness increases, the highlight becomes broader instead of sharp.
- Changing metallic changes the reflected color visibly.

## Fixed numeric targets

`base_color` defaults to `vec4(0.12, 0.58, 0.64, 1.0)`, `roughness_value` defaults to `0.28`, and `metallic_value` defaults to `0.72`.

## Hint 1

Use `vec4` and `source_color` for the color; use `float` for the other two parameters.

## Hint 2

Give float parameters a `hint_range` from 0 to 1.

## Hint 3

Write the values into `ALBEDO`, `ROUGHNESS`, and `METALLIC` respectively.
