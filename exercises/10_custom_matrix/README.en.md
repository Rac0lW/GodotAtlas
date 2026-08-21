# 10 · Custom Matrix

A matrix maps one set of coordinate axes to another. Rotation around Y only needs to operate in the XZ plane, so start by making the structure visible with a `mat2`.

## Task

Use `angle_degrees` to calculate radians, sine, and cosine, construct a 2D rotation matrix, and use it to transform `VERTEX.xz`.

## Acceptance

- At 0°, the model is unchanged.
- At 90°, the X and Z axes exchange correctly with the expected sign changes.
- The solution does not call an engine node rotation directly.

## Hint 1

Use `radians()` to convert degrees to radians.

## Hint 2

A 2D rotation matrix is built from `cos` and `sin`.

## Hint 3

Build `mat2(c, -s, s, c)` and multiply it by `VERTEX.xz`.
