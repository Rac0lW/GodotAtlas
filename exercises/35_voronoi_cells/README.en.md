# 35 · Voronoi Cells

Voronoi treats each grid cell as a region and places a feature point in that region. Each pixel only needs the nearest feature point to produce a cellular structure.

## Task

Scale UV to a 6 × 6 grid, search the surrounding 3 × 3 neighborhood, and output the distance to the nearest feature point.

## Acceptance

- The image contains repeated but not identical cell regions.
- Each cell center is brighter and its boundary is formed continuously by distance.
- Moving to a cell edge does not break because the search is limited to the current cell.

## Hint 1

Use `floor` for the current cell and `fract` for its local coordinate.

## Hint 2

Two `for` loops can visit the neighborhood where both X and Y range from -1 to 1.

## Hint 3

Keep the minimum distance with `min`, then use `smoothstep` to turn it into visible brightness.
