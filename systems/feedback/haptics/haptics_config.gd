class_name HapticsConfig
extends Resource

class HapticsEntry:
	extends Resource
	@export var event_name: String = ""
	@export_range(0.0, 1.0) var weak_magnitude: float = 0.0
	@export_range(0.0, 1.0) var strong_magnitude: float = 0.0
	@export var duration: float = 0.0

@export var entries: Array[HapticsEntry] = []


func get_entry(event_name: String) -> HapticsEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
