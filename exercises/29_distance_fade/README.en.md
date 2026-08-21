# 29 · Distance Fade

Distance fading needs world-space surface position and world-space camera position. Mixing in object space makes the fade logic change when the model moves or scales.

## Task

Pass world position from the vertex stage, calculate its distance to `CAMERA_POSITION_WORLD` in the fragment stage, and use `fade_near` and `fade_far` to control Alpha.

## Acceptance

- The result is fully opaque closer than `fade_near`.
- The result is fully transparent farther than `fade_far`.
- Moving the model or camera produces the same relative-distance behavior.

## Fixed numeric targets

`base_color` defaults to `vec4(0.12, 0.68, 0.58, 1.0)`, with an additional rim light of `vec3(0.15, 0.35, 0.3)`. The default values of `fade_near` and `fade_far` are `2.0` and `5.0`.

## Hint 1

World position still comes from `MODEL_MATRIX * vec4(VERTEX, 1.0)`.

## Hint 2

Use `distance(a, b)` for the distance.

## Hint 3

Alpha is `1.0 - smoothstep(fade_near, fade_far, camera_distance)`.
