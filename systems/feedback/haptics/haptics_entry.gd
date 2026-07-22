## A single named haptics entry.
class_name HapticsEntry
extends Resource

## The event name this entry triggers on (must match event_bus signal name).
@export var event_name: String = ""
## Rumble intensity for the small/low-frequency motor.
@export_range(0.0, 1.0) var weak_magnitude: float = 0.0
## Rumble intensity for the large/high-frequency motor.
@export_range(0.0, 1.0) var strong_magnitude: float = 0.0
## Duration of the rumble, in seconds.
@export var duration: float = 0.0
