## Listens for hitstop events on the event bus and briefly pauses/slows
## engine time based on a HitstopConfig resource. Overlapping events
## extend the pause rather than stacking/combining.
extends Node

const CHANNEL := "hitstop"

## The hitstop config resources mapping event names to timescale parameters.
@export var configs: Array[HitstopConfig] = []

var _end_time: float = 0.0
var _active: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.subscribe(CHANNEL, _on_hitstop_event)


func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_hitstop_event)


## Handles an incoming hitstop event and starts/extends the pause if a
## matching entry is found in any of [member configs].
func _on_hitstop_event(payload: Dictionary) -> void:
	var event_name: String = payload.get("event_name", "")
	var entry: HitstopEntry = null
	for config in configs:
		if config == null:
			continue
		entry = config.get_entry(event_name)
		if entry != null:
			break
	if entry == null:
		return

	var now := Time.get_ticks_msec() / 1000.0
	var new_end_time := now + entry.duration
	if new_end_time > _end_time:
		_end_time = new_end_time
	Engine.time_scale = entry.time_scale
	_active = true


## Restores normal time scale once the current hitstop has expired.
func _process(_delta: float) -> void:
	if not _active:
		return
	var now := Time.get_ticks_msec() / 1000.0
	if now >= _end_time:
		Engine.time_scale = 1.0
		_active = false
