## Listens for haptics events on the event bus and triggers gamepad rumble
## based on a HapticsConfig resource.
extends Node

const CHANNEL := "haptics"
const DEVICE := 0

## The haptics config resources mapping event names to rumble parameters.
@export var configs: Array[HapticsConfig] = []

func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_haptics_event)

func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_haptics_event)

## Handles an incoming haptics event and starts gamepad vibration if a
## matching entry is found in any of [member configs].
func _on_haptics_event(payload: Dictionary) -> void:
	var event_name: String = payload.get("event_name", "")
	for config in configs:
		if config == null:
			continue
		var entry := config.get_entry(event_name)
		if entry != null:
			Input.start_joy_vibration(DEVICE, entry.weak_magnitude, entry.strong_magnitude, entry.duration)
			return
