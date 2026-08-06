# Shader Atlas design system

## 1. Visual theme and atmosphere

Shader Atlas is a nocturnal technical manual fused with an oscilloscope workbench. The interface is precise, quiet and tactile: ink-navy surfaces, warm paper-white text and amber signal marks. Decoration stays off by default; the live render and its calibrated frame are the visual anchor.

The brand words are precise, nocturnal and tactile. Inter, IBM Plex Mono and Space Mono are rejected as reflex choices. Latin and numerals use Bahnschrift for its engineered narrow forms; Chinese falls through to Microsoft YaHei UI. Code and paths use Cascadia Mono with a Microsoft YaHei UI fallback.

## 2. Color palette and roles

| Token | Value | Role |
|---|---:|---|
| Canvas ink | `#080B0E` | Window background and deepest preview surround |
| Sidebar ink | `#0D1115` | Navigation surface |
| Work surface | `#11171C` | Lesson and preview workspace |
| Raised surface | `#172027` | Toolbars, selected rows and inline confirmations |
| Hairline | `#26323A` | Dividers and calibrated frame lines |
| Text primary | `#E7E2D6` | Main Chinese reading text |
| Text secondary | `#A3AAA8` | Summaries and metadata |
| Text muted | `#69747A` | Locked and inactive labels |
| Signal amber | `#F0A23A` | Current position, primary action and scanline |
| Signal bright | `#FFB54F` | Hover and focus state |
| Pass green | `#70C697` | Successful validation |
| Fault coral | `#DF7466` | Errors and destructive confirmation |

The palette uses a near-black blue-tinted neutral ladder. Amber is the only dominant accent. Green and coral appear only as semantic states.

## 3. Typography rules

| Level | Face | Size | Weight | Line height |
|---|---|---:|---:|---:|
| App mark | Bahnschrift + Microsoft YaHei UI | 18 | 600 | 1.15 |
| Exercise title | Bahnschrift + Microsoft YaHei UI | 28 | 600 | 1.25 |
| Section heading | Bahnschrift + Microsoft YaHei UI | 15 | 600 | 1.35 |
| Body Chinese | Bahnschrift + Microsoft YaHei UI | 15 | 400 | 1.75 |
| UI label | Bahnschrift + Microsoft YaHei UI | 13 | 500 | 1.35 |
| Code and counters | Cascadia Mono + Microsoft YaHei UI | 12 | 450 | 1.45 |

Chinese glyphs keep normal tracking. Counters use tabular numerals. Titles avoid forced uppercase and use sentence case.

## 4. Component styling

- Buttons use a fixed 4 px radius, 40 px minimum hit height and a 96 percent press scale. Primary buttons use amber fill with ink text; secondary buttons use a raised background; destructive actions use coral only during explicit confirmation.
- Navigation rows are flush, 40 px high and cardless. The current row uses a raised background plus a 6 px amber signal dot. Completed rows use a small green mark; locked rows reduce contrast without hiding their title.
- Lesson sections are borderless reading blocks separated by hairlines. Hints arrive inline beneath the task instead of opening a modal.
- The preview is the only prominent framed surface. Its calibrated border, corner coordinates and scanline form the design signature.
- Validation feedback occupies a fixed-height action strip so loading, failure and success never move surrounding controls.
- Reset uses an inline two-step confirmation with a visible recovery note. The current source is backed up before replacement.

## 5. Layout principles

The desktop shell has three continuous columns: 252 px navigation, 456 px lesson, and a flexible preview workspace. A 56 px top bar spans the lesson and preview region. Base spacing uses `4, 8, 12, 16, 24, 32` px; outer padding equals the main inner gap at 16 px.

The layout serves utility in this order: orient, show status, enable action. There is no hero. The preview remains the largest single region and the lesson text stays within a comfortable reading measure.

## 6. Depth and elevation

Depth comes from background steps, not dark drop shadows. Canvas, sidebar, work surface and raised controls each increase in lightness. Hairlines separate structural regions at one pixel. The preview frame may use a faint inner highlight, but generic panels do not receive shadows.

Radius scale: `r1 = 4 px`, `r2 = 8 px`, `r3 = 12 px`. Buttons use `r1`, inline status panels use `r2`, and the outer preview instrument uses `r3`.

## 7. Do and do not

- Do keep amber below roughly ten percent of visual weight.
- Do make the current exercise and validation state readable at a glance.
- Do keep source paths selectable and fully visible.
- Do preserve 40 px keyboard and pointer targets.
- Do show recovery consequences before reset.
- Do not use gradients, glass blur, neon cyan or decorative particle backgrounds.
- Do not put every section inside a rounded card.
- Do not truncate exercise titles with an ellipsis.
- Do not animate layout dimensions; use opacity and scale only.
- Do not expose the reference solution during normal validation.

## 8. Responsive behavior

The supported surface is a desktop Godot window at 1280 by 720 or larger. At 1280 px, navigation contracts to 224 px and the lesson column to 400 px; the preview takes the remainder. At 1440 px and above, the default 252 and 456 px columns apply. Below the supported width, the app keeps all actions reachable with split-container dragging instead of silently hiding columns.

Keyboard access: `Ctrl+Enter` validates, `Ctrl+R` enters reset confirmation, `H` reveals a hint, and `Alt+Left` or `Alt+Right` navigates. Focused controls use a bright amber outline.

## 9. Agent prompt guide

Quick colors: canvas `#080B0E`, sidebar `#0D1115`, work `#11171C`, raised `#172027`, line `#26323A`, text `#E7E2D6`, secondary `#A3AAA8`, amber `#F0A23A`, pass `#70C697`, fault `#DF7466`.

- Create a navigation row 40 px high on `#0D1115`, radius 4 px, Bahnschrift and Microsoft YaHei UI at 13 px weight 500; current state uses `#172027` and a 6 px `#F0A23A` dot, completed state uses a 5 px `#70C697` mark.
- Create a primary action 40 px high with 14 px horizontal padding, radius 4 px, `#F0A23A` fill and `#080B0E` text at 13 px weight 600; hover uses `#FFB54F`, press scales to 0.96 over 90 ms.
- Create the live preview instrument on `#080B0E`, outer radius 12 px, 1 px `#26323A` line, 16 px inner padding, amber corner coordinates in Cascadia Mono at 11 px and a 2 px scanline using `#F0A23A` at 72 percent opacity.
- Create a lesson heading in `#E7E2D6` at 28 px weight 600, followed by Chinese body copy at 15 px and 1.75 line height on `#11171C`; separate sections with a 1 px `#26323A` hairline and no card container.
- Create an inline reset confirmation on `#172027`, radius 8 px, 12 px padding, recovery copy in `#A3AAA8`, cancel as a secondary button and confirm in `#DF7466`; keep both actions 40 px high.
