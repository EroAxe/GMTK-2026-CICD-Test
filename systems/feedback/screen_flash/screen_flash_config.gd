class_name ScreenFlashConfig
extends Resource
## Data-driven screen flash configuration. Maps event names to full-screen
## color flash parameters.
##
## [codeblock]
## var entry := screenflash_config.get_entry("hit")
## if entry:
##     EventBus.fire("screenflash", {"event_name": "hit"})
## [/codeblock]

## The configured screen flash entries, edited in the inspector.
@export var entries: Array[ScreenFlashEntry] = []

## Returns the entry matching [param event_name], or null if none exists.
func get_entry(event_name: String) -> ScreenFlashEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
