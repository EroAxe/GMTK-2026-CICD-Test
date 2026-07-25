# Feedback System

Four independent systems: Haptics, ScreenShake, Hitstop, ScreenFlash. Same pattern for all: fire an event on the EventBus with an `event_name`. A handler autoload looks up a matching entry in one of its assigned Config resources and applies the effect.

## For Programmers

Each system listens on its own EventBus channel. Fire like this from anywhere:

```gdscript
EventBus.fire("haptics", {"event_name": "hit"})
EventBus.fire("screenshake", {"event_name": "hit"})
EventBus.fire("hitstop", {"event_name": "hit"})
EventBus.fire("screenflash", {"event_name": "hit"})
```

Channels:
- `"haptics"`: HapticsHandler. Triggers gamepad rumble. Supports overlapping events (sums weak/strong magnitudes, capped at 1.0).
- `"screenshake"`: ScreenShakeHandler. Offsets the active Camera2D. Supports overlapping events (layered, frequency-based).
- `"hitstop"`: HitstopHandler. Sets `Engine.time_scale`. Overlapping events extend the pause rather than stacking.
- `"screenflash"`: ScreenFlashHandler. Fades a full-screen ColorRect overlay. Newest event replaces the current flash (no layering).

All handlers are autoloads and resolve their target (camera, overlay) dynamically, so they work across scene changes without manual wiring. ScreenFlash requires a ColorRect in the `screen_flash_overlay` group to exist somewhere in the tree. This is already set up in the autoloaded overlay scene; you don't need to add it per-scene.

To add a new event, add an entry to the relevant Config resource (see below). No code changes are needed unless it's a genuinely new system.

## For Designers

Each system has a Config resource assigned to its handler in the autoload, containing a list of Entries. `event_name` in the entry must exactly match the string used when the event is fired.

### HapticsConfig / HapticsEntry
- `event_name`: string, must match fired event
- `weak_magnitude` (0–1): low-frequency motor intensity
- `strong_magnitude` (0–1): high-frequency motor intensity
- `duration`: seconds

### ScreenShakeConfig / ScreenShakeEntry
- `event_name`: string, must match fired event
- `amplitude`: how far the camera moves, in pixels
- `frequency`: how fast the shake oscillates
- `duration`: seconds

### HitstopConfig / HitstopEntry
- `event_name`: string, must match fired event
- `time_scale` (0–1): how slow time gets (0 = full freeze)
- `duration`: real seconds the pause lasts

### ScreenFlashConfig / ScreenFlashEntry
- `event_name`: string, must match fired event
- `color`: flash color; alpha channel is the peak intensity
- `duration`: seconds for the flash to fade to 0

To add a new effect for an event (e.g. a new "explosion" feedback), add a matching `event_name` entry to each Config you want it to trigger in, then fire all the relevant channels together when the event happens in gameplay code.
