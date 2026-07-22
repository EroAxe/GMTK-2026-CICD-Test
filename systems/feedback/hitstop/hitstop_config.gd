class_name HitstopConfig
extends Resource
## Data-driven hitstop configuration. Maps event names to timescale
## pause parameters.
##
## [codeblock]
## var entry := hitstop_config.get_entry("hit")
## if entry:
##     EventBus.fire("hitstop", {"event_name": "hit"})
## [/codeblock]

## The configured hitstop entries, edited in the inspector.
@export var entries: Array[HitstopEntry] = []

## Returns the entry matching [param event_name], or null if none exists.
func get_entry(event_name: String) -> HitstopEntry:
	for entry in entries:
		if entry.event_name == event_name:
			return entry
	return null
