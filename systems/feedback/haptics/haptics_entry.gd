## A single named haptics entry.
class_name HapticsEntry
extends Resource

@export var event_name: String = ""
@export_range(0.0, 1.0) var weak_magnitude: float = 0.0
@export_range(0.0, 1.0) var strong_magnitude: float = 0.0
@export var duration: float = 0.0
