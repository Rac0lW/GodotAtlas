# 36 · fBm Fractal Layers

One noise layer has only one scale. fBm adds noise at several frequencies with decreasing amplitudes, allowing large shapes and fine detail to coexist; it is a common starting point for procedural clouds, rocks, and smoke.

## Task

Reuse Value Noise and add 5 octaves: double the frequency and halve the amplitude at each layer, then output the total as grayscale.

## Acceptance

- The image contains both broad changes and fine texture.
- Adding octaves increases detail while overall brightness stays near 0 through 1.
- Every sample still comes from a deterministic noise function.

## Hint 1

Maintain `frequency` in the loop, or multiply the sample coordinate by 2 each iteration.

## Hint 2

Start amplitude at `0.5` and multiply it by `0.5` each layer.

## Hint 3

Multiply each `value_noise` result by the current amplitude and add it to `total`.
