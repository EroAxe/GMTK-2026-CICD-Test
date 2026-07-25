# Credits System

## Overview

Two-part system: a **config** holding the actual credit entries, and a **handler** that displays them.

## CreditsEntry (`credits_entry.gd`)

Single credit entry.

- `role: String` — e.g. "Programmer", "Artist"
- `entry_name: String` — person's name

## CreditsConfig (`credits_config.gd`)

Holds the list of entries.

- `entries: Array[CreditsEntry]`

Create a `.tres` resource of type `CreditsConfig`, add `CreditsEntry` resources to `entries` via the Inspector. This is the single place to edit the actual credits list.

## Handler (`credits.gd`)

Attached to a `Control` node, displays and scrolls the credits.

### Scene setup
```
Control (credits.gd)
 └─ ScrollContainer
     └─ VBoxContainer
```

### Behavior

- On `_ready()`, groups all entries by `role`.
- Roles are sorted alphabetically.
- Names within each role are sorted alphabetically.
- Each role is rendered as a header label, followed by an underline (`ColorRect`), followed by its names.
- A spacer `Control` is inserted between role groups (not after the last one).
- Auto-scrolls vertically via `_process`, and frees itself (`queue_free`) once scrolled past the content height.

### Exposed variables (tweak in Inspector)

| Variable | Purpose |
|---|---|
| `credits_config` | The `CreditsConfig` resource to display |
| `scroll_speed` | Pixels/sec scroll rate |
| `header_font` | Optional font override for role headers |
| `header_font_size` | Font size for role headers |
| `name_font_size` | Font size for names |
| `spacing_between_roles` | Vertical space (px) inserted between role groups |

### Adding/editing credits

Edit `credits_config.tres` only — add/remove `CreditsEntry` items, set `role` and `entry_name`. No script changes needed; sorting and grouping happen automatically at runtime.
