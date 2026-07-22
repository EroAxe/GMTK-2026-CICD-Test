## A single named screenshake entry.
class_name ScreenShakeEntry
extends Resource

## The event name this entry triggers on (must match event_bus signal name).
@export var event_name: String = ""
## How far the camera offset moves, in pixels.
@export var amplitude: float = 0.0
## How fast the shake oscillates.
@export var frequency: float = 20.0
## Duration of the shake, in seconds.
@export var duration: float = 0.0
