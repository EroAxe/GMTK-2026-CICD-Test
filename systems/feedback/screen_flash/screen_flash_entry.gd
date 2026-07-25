## A single named screen flash entry.
class_name ScreenFlashEntry
extends Resource

## The event name this entry triggers on (must match event_bus signal name).
@export var event_name: String = ""
## The flash color (alpha is used as peak intensity).
@export var color: Color = Color(1, 1, 1, 1)
## Duration of the flash fade-out, in seconds.
@export var duration: float = 0.0
