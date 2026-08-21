# 23 · Vertex Wave

Vertex animation changes the mesh silhouette rather than surface color. Vertex density directly affects wave quality, so the preview uses a highly subdivided plane.

## Task

Use object-space X and `TIME` to calculate a sine wave, add it to `VERTEX.y`, and pass the wave height to the fragment stage for shading.

## Acceptance

- The plane silhouette actually moves instead of only changing color.
- Setting `amplitude` to zero restores a flat plane.
- Adjacent vertices remain continuous without random breaks.

## Fixed numeric targets

The low color is `vec3(0.03, 0.18, 0.28)` and the high color is `vec3(0.14, 0.82, 0.72)`. The default values of `amplitude`, `frequency`, and `speed` are `0.28`, `5.0`, and `1.6`.

## Hint 1

The phase can be `VERTEX.x * frequency + TIME * speed`.

## Hint 2

The wave value is `sin(phase) * amplitude`.

## Hint 3

Calculate and save the wave value to a varying before modifying the vertex.
