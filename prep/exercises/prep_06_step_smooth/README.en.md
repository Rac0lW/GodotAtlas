# P06 · Hard and Soft Edges

Both `step` and `smoothstep` turn a value into a mask. The former switches instantly at a threshold; the latter transitions smoothly between two boundaries.

## Task

Draw a hard edge and a soft edge across `UV.x`. Every pixel must use the numeric formula below; do not replace the blue or Alpha values:

```glsl
float hard_edge = step(0.5, UV.x);
float soft_edge = smoothstep(0.25, 0.75, UV.x);
COLOR = vec4(hard_edge, soft_edge, 0.18, 1.0);
```

## Acceptance

- The red channel is `step(0.5, UV.x)`, so it is `0.0` when `UV.x < 0.5` and `1.0` when `UV.x >= 0.5`.
- The green channel is `smoothstep(0.25, 0.75, UV.x)`, changing continuously from `0.0` to `1.0` between the two boundaries.
- Blue is fixed at `0.18` and Alpha at `1.0`. For example, at `UV.x = 0.5`, the target RGBA is `(1.0, 0.5, 0.18, 1.0)`.
- The Shader compiles in the prep preview and passes numeric image validation.

## Hint 1

`step(edge, value)` returns only `0` or `1`.

## Hint 2

`smoothstep(edge0, edge1, value)` maps the interval to `0` through `1`.

## Hint 3

Put the two results in the red and green channels of `vec4(hard, soft, 0.18, 1.0)`.
