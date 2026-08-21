# 32 · Capstone: Signal Storm

The final exercise no longer tests only one formula. Put three independent signals in the right stages: vertex pulsing changes the silhouette, Fresnel describes the viewing angle, and procedural noise controls surface dissolve.

## Task

Complete vertex pulsing, world-space noise, and Fresnel. Use `dissolve_threshold` to control discarded regions, add warm emission along the dissolve edge, and write an explanation identifying the space used by each calculation.

## Acceptance

- The model silhouette has continuous breathing motion.
- Dissolve is not a simple top-to-bottom crop and changes slowly over time.
- Rim light responds to camera angle and the dissolve edge has its own emission color.
- Add at least three sentences of implementation notes at the end of this README.

## Fixed numeric targets

`base_color` defaults to `vec4(0.035, 0.2, 0.24, 1.0)`, `rim_color` to `vec4(0.14, 0.92, 0.76, 1.0)`, and `edge_color` to `vec4(1.0, 0.42, 0.08, 1.0)`. The default values of `pulse_amount` and `dissolve_threshold` are `0.07` and `0.42`.

## Hint 1

Vertex pulsing works well by moving vertices along the object-space normal.

## Hint 2

Feeding world position into a simple hash function produces noise that does not stick to the screen.

## Hint 3

Build a narrow edge from the difference between noise and the threshold, then write it to `EMISSION`.

## My implementation notes

After completing the exercise, explain which space vertex pulsing, Fresnel, and dissolve use, and why.
