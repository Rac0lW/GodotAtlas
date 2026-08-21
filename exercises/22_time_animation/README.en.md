# 22 · Time Signal

`TIME` is a steadily increasing number of seconds. Putting it into a sine function creates a stable periodic signal; mapping that signal to 0 through 1 lets it drive a radius, color, or intensity.

## Task

Pulse the ring radius with `pulse_speed`, while making the color move slowly back and forth between `color_a` and `color_b`.

## Acceptance

- The animation loops continuously without a sudden jump.
- The radius always stays positive.
- Changing the speed parameter changes the motion frequency.

## Fixed numeric targets

`color_a` defaults to `vec4(0.1, 0.82, 0.72, 1.0)`, `color_b` defaults to `vec4(0.96, 0.44, 0.14, 1.0)`, and the background is fixed at `vec3(0.02, 0.035, 0.06)`. `pulse_speed` defaults to `2.0`.

## Hint 1

The periodic signal is `sin(TIME * speed)`.

## Hint 2

Multiply it by 0.5 and add 0.5 to get a value from 0 to 1.

## Hint 3

Use `abs(length(point) - animated_radius)` for the ring distance.
