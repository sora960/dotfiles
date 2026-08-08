# E-Ink Screen Shader — Implementation Notes

A trace of how the custom e-ink `screen_shader` was wired into a Hyprland
0.55+ (Lua config) setup, every wrong turn taken along the way, and why the
final version works. Written to be read back later, not just followed once.

---

## 1. What we built

- `~/dotfiles/hypr/shaders/eink.frag` — a GLSL fragment shader that
  desaturates the screen, applies an e-ink-style tone curve, and layers
  paper grain / dithering noise on top.
- A binding in `keybindings.lua` (`SUPER + SHIFT + T`) that toggles the
  shader on and off live, without needing a full config reload.
- `screen_shader` is also set once at boot in `hyprland.lua`'s main
  `decoration` block, so it's active by default on login.

---

## 2. GLSL version — the first wall

### The mistake
The original shader used `#version 320 es`. That looks reasonable —
it's a real GLSL ES version — but Hyprland's shader linker doesn't
support it:

> `GLSL ES 3.20 is not supported. Supported versions are: 1.00 ES, and 3.0 ES`

### The overcorrection
The first fix attempt went too far in the other direction: it dropped
the version line entirely and rewrote the whole shader in legacy
GLSL ES 1.00 style (`varying`, `texture2D`, `gl_FragColor`). This
*compiled*, but broke linking against Hyprland's internal vertex shader,
which expects a specific version to match:

> `Error linking program: error: all shaders must use same shading language version`

### The actual fix
Keep the modern syntax (`in`/`out` qualifiers, `texture()`, a declared
`out vec4 fragColor`), just change the version number:

```glsl
#version 300 es   // not 320 es, not omitted
precision highp float;

in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 fragColor;
```

**Lesson:** when a compositor gives you a version-mismatch error, check
what versions it actually supports before guessing a fix in either
direction. `1.00 ES` and `3.0 ES` are Hyprland's only two supported
targets — nothing in between, nothing above.

---

## 3. Classic config vs. the Lua config

Hyprland 0.55 introduced a Lua-based config (`hyprland.lua`,
`keybindings.lua`, etc., using the `hl.*` API) alongside the older
plain-text `hyprland.conf` format (`hyprlang`). They are **not
interchangeable syntax** — this bit us twice:

| Classic (`hyprland.conf`)                          | Lua (`hyprland.lua`)                                      |
|------------------------------------------------------|-------------------------------------------------------------|
| `decoration { screen_shader = /path }`               | `hl.config({ decoration = { screen_shader = "/path" } })`   |
| `hyprctl keyword decoration:screen_shader /path`     | `hyprctl eval 'hl.config({...})'` or call `hl.config()` from inside a Lua bind |

Running `hyprctl keyword ...` against a Lua-parsed config fails outright:

> `keyword can't work with non-legacy parsers. Use eval.`

**Lesson:** check which config system is actually in play (`ls ~/.config/hypr`
— `.lua` files vs `.conf`) before copying commands from docs/forums, since
most existing tutorials (including hyprshade's own docs) still assume the
classic `hyprctl keyword` syntax.

---

## 4. The toggle keybind

Final version, in `keybindings.lua`:

```lua
local einkShaderPath = "/home/lucy/dotfiles/hypr/shaders/eink.frag"
local einkShaderOn = true

local function toggle_eink_shader()
    einkShaderOn = not einkShaderOn

    if einkShaderOn then
        hl.config({
            decoration = {
                shadow = { enabled = false },
                blur = { enabled = false },
            },
            animations = { enabled = false },
            debug = { damage_tracking = 0 },
        })
        hl.config({ decoration = { screen_shader = einkShaderPath } })
    else
        hl.config({ decoration = { screen_shader = "" } })
        hl.config({
            decoration = {
                shadow = { enabled = true },
                blur = { enabled = true },
            },
            animations = { enabled = true },
            debug = { damage_tracking = 2 },
        })
    end
end

hl.bind(mainMod .. " + SHIFT + T", toggle_eink_shader)
```

State is tracked in a plain Lua local (`einkShaderOn`), not by querying
`hyprctl getoption` each time — the function is the single source of truth
for what it last set, which is simpler and avoids a round-trip.

---

## 5. The flicker — root cause

### What it looked like
Toggling the shader on/off produced a visible flicker/glitch during the
swap. Not a crash, not a black screen — just an ugly transition.

### Where the investigation went first (and why it stalled)
Checked, in order:
1. `journalctl --user` around the toggle moment — empty.
2. `sudo dmesg -T` — clean, no `amdgpu`/DRM errors.
3. Hyprland's own log file — didn't even exist at the expected path.
4. `hyprctl systeminfo` — nothing relevant.

All three log sources were clean, which led to an initial (wrong)
conclusion: "nothing is failing, so this must just be inherent to how
`screen_shader` hot-swaps — not fixable."

### Why that conclusion was wrong
Logs catch **failures** — crashes, GL errors, driver faults. They don't
catch **visual interactions between two things that are each working
correctly on their own**. Blur and shadow are their own compositor render
passes, operating on the same framebuffer region a full-screen
post-process shader also touches. Swapping the shader in/out while those
passes are still actively compositing produces a visible seam — with
nothing to log, because nothing actually errored.

### How it was actually found
Not through more log-digging — by comparing against a real working
reference implementation (the shader's original author's own dotfiles).
Their `shader.lua` **never** activates a screen shader without first
disabling blur, shadow, and animations, and in heavier shader modes also
sets `debug.damage_tracking = 0`. Every single shader-toggle function in
their code follows the same two-step pattern:

1. One `hl.config()` call to kill blur/shadow/animations/damage-tracking.
2. A **separate** `hl.config()` call to set `screen_shader` itself.

This is folklore knowledge in the Hyprland shader community — it doesn't
show up as a filed bug report anywhere, because from the compositor's
perspective nothing is actually broken. It's a config-level gotcha you
only learn by seeing how people who've actually shipped a custom
`screen_shader` structure their toggle logic.

### `damage_tracking`, briefly
Hyprland normally only repaints screen regions that changed
(`debug:damage_tracking`, default partial/smart tracking) for
performance. A full-screen shader recomputes the *entire* frame from
`gl_FragCoord` every time — so if damage tracking is still doing
partial-region repaints while the shader attaches/detaches, the shaded
and unshaded regions can briefly disagree on-screen. Setting
`damage_tracking = 0` forces full-frame repaints, removing that mismatch
window. It's reset back to `2` when the shader turns off, since partial
damage tracking is a real performance win the rest of the time.

---

## 6. Debugging approach that actually worked (for next time)

Rough order of what helped, most useful last:

1. ❌ Guessing a fix and testing it live (worked eventually, but slow —
   several round trips of "try this, get a new error").
2. ❌ Exhaustive log-checking (`journalctl`, `dmesg`, `hyprland.log`) —
   ruled out crashes, but a flicker caused by a *feature interaction*
   was never going to show up as an error in the first place.
3. ✅ Reading the actual upstream error message text closely and
   searching for it verbatim (`"all shaders must use same shading
   language version"`) — found the exact GitHub issue/discussion
   explaining the real constraint.
4. ✅✅ Finding a **real, working reference implementation** written by
   someone who solved the same problem — this is what actually cracked
   the flicker. Official docs and issue trackers document *bugs*; they
   don't document *"here's the non-obvious config pattern you need to
   avoid an ugly-but-not-broken interaction."* That kind of knowledge
   mostly lives in people's actual dotfiles.

**Takeaway:** when something is visually wrong but nothing is logging an
error, stop searching for a bug and start searching for how someone else
who built the same feature structured their solution.

---

## 7. Final file reference

- Shader: `~/dotfiles/hypr/shaders/eink.frag` (GLSL ES 3.00)
- Boot-time default: `hyprland.lua` → `decoration.screen_shader`
- Toggle bind: `keybindings.lua` → `SUPER + SHIFT + T`
- Verify current state any time: `hyprctl getoption decoration:screen_shader`
