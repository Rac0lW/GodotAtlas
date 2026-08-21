# 25 · Rotation Matrix

A single-axis matrix is easy to understand, while practical rotations often combine several axes. Matrix multiplication is not commutative, so XYZ and ZYX produce different results.

## Task

Build X, Y, and Z rotation matrices from three angles, then transform the vertex in the order `rotation_z * rotation_y * rotation_x`.

## Acceptance

- Each axis has its own uniform.
- Changing only one angle rotates the model around the corresponding axis.
- Changing multiplication order creates an observable difference.

## Hint 1

Convert all three angles to radians first.

## Hint 2

Each `mat3` contains sine and cosine only in its corresponding 2D plane.

## Hint 3

Finally write `VERTEX = rotation_z * rotation_y * rotation_x * VERTEX;`.
