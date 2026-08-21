# 21 · Procedural Character

A procedural character does not depend on a complicated formula so much as a clear hierarchy: establish the head mask, add eyes, nose, and mouth, then decide how the layers overlap.

## Task

Use circle distances for the head and both eyes, and a ring distance for the curved mouth. Derive every part from centered UV; do not sample a texture.

## Acceptance

- The head is warm-colored and the background stays dark.
- The two eyes are symmetric.
- The mouth is an arc rather than a filled circle.

## Fixed numeric targets

The background is fixed at `vec3(0.025, 0.045, 0.075)`, skin at `vec3(0.93, 0.58, 0.25)`, linework at `vec3(0.035, 0.055, 0.08)`, and Alpha at `1.0`.

## Hint 1

Combine the eyes with `min(left_eye, right_eye)`.

## Hint 2

A ring distance can be `abs(length(p) - radius) - thickness`.

## Hint 3

Add a Y-direction cut to the mouth and keep only the lower half of the ring.
