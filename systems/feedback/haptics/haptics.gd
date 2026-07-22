extends Node

const CHANNEL := "haptics"
const DEVICE := 0

@export var config: HapticsConfig


func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_haptics_event)


func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_haptics_event)


func _on_haptics_event(payload: Dictionary) -> void:
	if config == null:
		return

	var event_name: String = payload.get("event_name", "")
	var entry := config.get_entry(event_name)
	if entry == null:
		return

	Input.start_joy_vibration(DEVICE, entry.weak_magnitude, entry.strong_magnitude, entry.duration)
