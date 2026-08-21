# 06 · World Gradient

An object-space gradient moves with the model. A world-space gradient behaves like a layer of colored fog in the scene, so every model passing through it receives the same color.

## Task

Pass world-space Y into the fragment stage. Use `gradient_low` and `gradient_high` as the bounds and interpolate between `cold_color` and `warm_color`.

## Acceptance

- All four specified uniforms exist.
- When the model moves, the color boundary stays in its original world position.
- Colors outside the bounds remain stable instead of extrapolating forever.

## Fixed numeric targets

`cold_color` defaults to `vec4(0.05, 0.22, 0.42, 1.0)` and `warm_color` defaults to `vec4(1.0, 0.48, 0.16, 1.0)`. The default values of `gradient_low` and `gradient_high` are `-0.7` and `0.7`.

## Hint 1

Reuse the previous varying, but store world-space height in it.

## Hint 2

`smoothstep(low, high, value)` already clamps the result to `0` through `1`.

## Hint 3

World height comes from `(MODEL_MATRIX * vec4(VERTEX, 1.0)).y`.
