# 27 · Game Boy Post-Process

Full-screen post-processing reads the already rendered screen texture and transforms the final pixels. Pixelation changes the sample coordinate, while a four-color effect quantizes brightness.

## Task

Align `SCREEN_UV` to a `pixel_size` grid, sample the screen texture, calculate perceptual luminance, and map it to four fixed green levels.

## Acceptance

- Increasing `pixel_size` makes the pixel blocks grow with it.
- The output contains only four main colors rather than continuous grayscale.
- Use `filter_nearest` so block edges stay crisp.

## Fixed numeric targets

The four palette levels are `vec3(0.055, 0.16, 0.13)`, `vec3(0.18, 0.34, 0.22)`, `vec3(0.48, 0.58, 0.28)`, and `vec3(0.78, 0.82, 0.42)` in order. `pixel_size` defaults to `5.0`.

## Hint 1

Screen pixel size is `1.0 / SCREEN_PIXEL_SIZE`.

## Hint 2

Align the grid with `floor(pixel_coordinate / size) * size`.

## Hint 3

Use luminance weights such as `vec3(0.2126, 0.7152, 0.0722)`.
