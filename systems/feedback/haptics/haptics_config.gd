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

## The configured haptics entries, edited in the inspector.
@export var entries: Array[HapticsEntry] = []

## Returns the entry matching [param event_name], or null if none exists.
func get_entry(event_name: String) -> HapticsEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
