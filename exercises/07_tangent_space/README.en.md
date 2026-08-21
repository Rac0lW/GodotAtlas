# 07 · Tangent Space

Normal maps usually store directions in tangent space. Treating them directly as view-space normals makes the bump direction wrong when the model rotates. `TANGENT`, `BINORMAL`, and `NORMAL` form the TBN basis.

## Task

Keep the procedurally generated tangent-space normal, construct a TBN matrix, transform it into view space, and write it to `NORMAL`.

## Acceptance

- Construct a `mat3` from `TANGENT`, `BINORMAL`, and `NORMAL`.
- Normalize the transformed normal.
- When the model rotates, the detailed lighting stays attached to its surface.

## Fixed numeric targets

Keep `ALBEDO = vec3(0.16, 0.56, 0.62)`, use the default `bump_strength` value `0.35`, and keep `ROUGHNESS` fixed at `0.45`. These are numeric validation targets, not subjective color names.

## Hint 1

The three matrix columns are tangent, bitangent, and geometric normal.

## Hint 2

Transform in the direction `tbn * normal_ts`.

## Hint 3

Write `NORMAL = normalize(tbn * normal_ts);` at the end.
