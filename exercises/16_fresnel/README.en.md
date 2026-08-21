# 16 · Fresnel Rim Light

When the view direction nearly grazes a surface, `dot(NORMAL, VIEW)` approaches zero. `1 - dot` produces an edge signal, and a power exponent controls the rim width.

## Task

Compute a Fresnel term and add `rim_color` to `base_color` according to its strength. A higher `rim_power` should make the edge narrower.

## Acceptance

- The center facing the camera keeps the base color.
- The silhouette becomes visibly brighter.
- Changing `rim_power` changes the rim width.

## Fixed numeric targets

`base_color` defaults to `vec4(0.035, 0.08, 0.14, 1.0)`, `rim_color` defaults to `vec4(0.2, 0.95, 0.82, 1.0)`, and `rim_power` defaults to `3.0`.

## Hint 1

Clamp the dot product to the range 0 through 1 first.

## Hint 2

The base signal is `1.0 - max(dot(NORMAL, VIEW), 0.0)`.

## Hint 3

Apply `pow(signal, rim_power)` to the base signal.
