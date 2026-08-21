# 14 · Blinn–Phong

Blinn–Phong uses the halfway vector between light and view directions. The closer the normal is to that halfway vector, the stronger the highlight; a larger exponent concentrates the highlight.

## Task

Keep the Lambert diffuse term, calculate `half_direction = normalize(LIGHT + VIEW)`, and add `pow(max(dot(NORMAL, half_direction), 0.0), shininess)` to `SPECULAR_LIGHT`.

## Acceptance

- The highlight moves with the camera or light.
- Increasing `shininess` makes the highlight smaller.
- A fully lit-looking highlight does not appear on the back side.

## Fixed numeric targets

`base_color` defaults to `vec4(0.1, 0.42, 0.72, 1.0)` and `shininess` defaults to `48.0`. The highlight must not be faked by changing the base color.

## Hint 1

The specular term should also be multiplied by light color and attenuation.

## Hint 2

Use the diffuse term to limit highlights on the back side.

## Hint 3

Multiply the highlight by `step(0.0, dot(NORMAL, LIGHT))`.
