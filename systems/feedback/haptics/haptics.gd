## Listens for haptics events on the event bus and triggers gamepad rumble
## based on a HapticsConfig resource.
extends Node

const CHANNEL := "haptics"
const DEVICE := 0

## The haptics config resource mapping event names to rumble parameters.
@export var config: HapticsConfig

func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_haptics_event)

func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_haptics_event)

## Handles an incoming haptics event and starts gamepad vibration if a
## matching entry is found in [member config].
func _on_haptics_event(payload: Dictionary) -> void:
	if config == null:
		return
	var event_name: String = payload.get("event_name", "")
	var entry := config.get_entry(event_name)
	if entry == null:
		return
	Input.start_joy_vibration(DEVICE, entry.weak_magnitude, entry.strong_magnitude, entry.duration)
