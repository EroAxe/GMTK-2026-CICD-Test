class_name HapticsConfig
extends Resource
## Data-driven haptics configuration. Maps event names to gamepad
## rumble parameters.
##
## [codeblock]
## var entry := haptics_config.get_entry("hit")
## if entry:
##     Input.start_joy_vibration(0, entry.weak_magnitude, entry.strong_magnitude, entry.duration)
## [/codeblock]

## A single named haptics entry.
class HapticsEntry:
	extends Resource
	@export var event_name: String = ""
	@export_range(0.0, 1.0) var weak_magnitude: float = 0.0
	@export_range(0.0, 1.0) var strong_magnitude: float = 0.0
	@export var duration: float = 0.0

## The configured haptics entries, edited in the inspector.
@export var entries: Array[HapticsEntry] = []


## Returns the entry matching [param event_name], or null if none exists.
func get_entry(event_name: String) -> HapticsEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
