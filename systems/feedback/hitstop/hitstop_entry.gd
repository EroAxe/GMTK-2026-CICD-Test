## A single named hitstop entry.
class_name HitstopEntry
extends Resource

## The event name this entry triggers on (must match event_bus signal name).
@export var event_name: String = ""
## How long time is paused/slowed, in real seconds.
@export var duration: float = 0.0
## Timescale applied during the hitstop (0 = full freeze).
@export_range(0.0, 1.0) var time_scale: float = 0.0
