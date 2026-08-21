# 37 · Texture Sampling

Procedural graphics often need to blend with an existing image. `sampler2D` represents a 2D texture, and `SCREEN_UV` gives the current pixel's sample coordinate in the screen texture.

## Task

Declare a `sampler2D screen_texture`, read the post-process input with `texture(screen_texture, SCREEN_UV)`, and output it unchanged.

## Acceptance

- The Shader declares `sampler2D screen_texture`.
- The image comes from the screen texture rather than a fixed color.
- The sample coordinate is `SCREEN_UV`, so the image is not shifted as a whole.

## Hint 1

Godot's screen texture declaration needs `hint_screen_texture`.

## Hint 2

The post-process fragment function already provides `SCREEN_UV`.

## Hint 3

`COLOR = texture(screen_texture, SCREEN_UV);` completes the unchanged sample first.
