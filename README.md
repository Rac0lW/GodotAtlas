# Shader Atlas

[中文文档](README.zh-CN.md)

Shader Atlas is a native Godot 4.7.1 interactive Shader course. Its early curriculum skeleton follows the topic order of *The Book of Godot Shaders*, from meshes and lighting through procedural effects and post-processing; this project redesigns the lessons, code, previews, and validation for 38 main exercises and 9 prep exercises. The exercise system also borrows the short exercises, standalone solutions, and automatic feedback structure of `100-exercises-to-learn-rust`.

![Shader Atlas 1440×900 interface](docs/screenshots/shader-atlas-1440.png)

## Getting started

1. Open `project.godot` in Godot 4.7.1.
2. Press F5 to run the project; the main scene is `workshop/main.tscn`.
3. Choose an exercise in the left sidebar and read its task and acceptance criteria in the center panel.
4. Click “Open Shader”, edit `exercises/<id>/exercise.gdshader`, and save the file.
5. Workshop detects the file change and refreshes the live preview on the right.
6. Click “Run validation”; passing an exercise unlocks the next one.

The project has no third-party plugin dependency and does not need a separate course runner.

## Interaction

On first launch, the `Guide` walkthrough explains the three-step workflow. Reopen it from the top toolbar at any time.

| Action | Entry point |
|---|---|
| Reopen onboarding | `Guide` in the top toolbar |
| Switch interface language | “English” / “中文” in the top toolbar |
| Run validation | `Ctrl+Enter` |
| Reset the current exercise | `Ctrl+R` |
| Reset the whole course | “Reset all” in the sidebar |
| Toggle developer mode | “DEV · OFF” in the sidebar |
| Reveal the next hint | `H` |
| Previous exercise | `Alt+Left` |
| Next exercise | `Alt+Right` |
| Cancel reset confirmation | `Esc` |

The language switch updates the workspace UI, navigation metadata, current lesson, hints, and manual observation checklists. English lessons are stored beside each Chinese `README.md` as `README.en.md`.

Each exercise provides three progressive hints. Resetting the current exercise or the whole course requires a second confirmation. A full reset backs up all 38 main exercise sources, 9 prep sources, and progress, then restores starters, clears completion and hints, and returns to main exercise 1. Backups are stored in `user://shader_atlas/backups`. Reference solutions live in `solutions/` and never overwrite learner files.

## Curriculum

- Module 0: fragment output and uniforms.
- Module 1: mesh attributes, coordinate spaces, varyings, tangent space, and matrices.
- Module 2: material channels, Lambert, Blinn–Phong, Fresnel, anisotropy, and normals.
- Module 3: SDFs, procedural characters, time animation, vertex waves, UI sweeps, and quaternions.
- Module 4: post-processing, Shadertoy ports, transparency, ray marching, and stencil buffers.
- Module 5: a capstone combining vertex pulsing, Fresnel, and dissolve.
- Module 6: reproducible randomness, Value Noise, Voronoi, fBm, and screen-texture UV warping.
- Prep bridge: `step`/`smoothstep`, centered coordinates, `TIME` waveforms, and uniform parameters.

See the [curriculum map](docs/CURRICULUM.md) for the complete mapping. See [sources and adaptation method](docs/SOURCES_AND_METHOD.md) for source and private-use boundaries.

## Validation

Most exercises render the learner Shader and reference Shader side by side, then compare 64×64 downsampled images. Interfaces that cannot be judged from one frame use source contracts, including ShaderInclude, uniforms, and stencil modes. Exercises that depend on camera motion, transparency ordering, or interpretation also show a manual observation checklist.

Learners do not need to copy the solution. An exercise passes when its rendered result, required interfaces, and observation conditions all match.

## Progress and private assets

Progress is stored in `user://shader_atlas/progress.json`. If the file is corrupted, the program keeps a timestamped original and creates a fresh save.

Developer mode removes prerequisite locks only for the current run, allowing direct jumps to any exercise. It does not alter completion records or write developer-mode state to the progress save.

When `res://assets_v17/assets` is present, the lower-left status reads `PRIVATE ASSETS · DETECTED`. Core exercises always use bundled geometry and procedural fixtures, so removing that directory does not break the course.

This project is made for private use. Do not redistribute source-book images or bundled companion assets.

## Project layout

```text
course/                 course catalog and validation configuration
exercises/<id>/         lesson, current exercise, and starter snapshot
solutions/              standalone reference solutions
shared/shaders/         ShaderInclude files and template-writing shaders
workshop/               Godot UI, course session, preview, and validation runtime
tests/                  structural and real GPU rendering tests
docs/                   curriculum, architecture, sources, and design notes
```

See [DESIGN.md](DESIGN.md) for interface rules, [architecture](docs/ARCHITECTURE.md) for runtime responsibilities, and [data flow](docs/DATA_FLOW.md) for the complete data path.

## Verification commands

Structural validation:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\validate_course.ps1
```

Run the real GPU tests in batches to avoid keeping too many rendering pipelines alive at once:

```powershell
godot --path . --rendering-driver d3d12 --script res://tests/shader_render_smoke.gd -- --from=1 --to=10
godot --path . --rendering-driver d3d12 --script res://tests/shader_render_smoke.gd -- --from=11 --to=20
godot --path . --rendering-driver d3d12 --script res://tests/shader_render_smoke.gd -- --from=21 --to=32
godot --path . --rendering-driver d3d12 --script res://tests/shader_render_smoke.gd -- --from=33 --to=38
```

Each batch confirms that solutions pass visual comparison and starters do not pass accidentally. Exercise 31 uses template contracts and a manual observation checklist.
