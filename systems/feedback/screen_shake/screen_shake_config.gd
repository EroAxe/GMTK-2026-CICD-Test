class_name ScreenShakeConfig
extends Resource
## Data-driven screenshake configuration. Maps event names to camera
## shake parameters.
##
## [codeblock]
## var entry := screenshake_config.get_entry("hit")
## if entry:
##     ScreenShake.trigger(entry.amplitude, entry.frequency, entry.duration)
## [/codeblock]

## The configured screenshake entries, edited in the inspector.
@export var entries: Array[ScreenShakeEntry] = []

## Returns the entry matching [param event_name], or null if none exists.
func get_entry(event_name: String) -> ScreenShakeEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
