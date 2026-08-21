# 26 · Quaternion Rotation

A unit quaternion represents a rotation with one scalar and one 3D vector. Converting axis-angle to a quaternion lets the cross-product formula rotate a vector directly and avoids the gimbal issues of composing Euler axes one at a time.

## Task

Implement axis-angle to quaternion conversion and a quaternion vector-rotation function. Use `rotation_axis` and `angle_degrees` to rotate the vertex.

## Acceptance

- Normalize the rotation axis before using it.
- Use the half-angle when calculating the quaternion.
- At 0°, the vertex is exactly unchanged.

## Hint 1

The quaternion vector part is `axis * sin(half_angle)` and the scalar part is `cos(half_angle)`.

## Hint 2

Store the quaternion as `vec4(xyz, w)`.

## Hint 3

The rotation formula is `v + 2.0 * cross(q.xyz, cross(q.xyz, v) + q.w * v)`.
