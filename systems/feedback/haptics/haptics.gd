## Listens for haptics events on the event bus and triggers gamepad rumble
## based on a HapticsConfig resource. Supports overlapping/simultaneous
## events by summing their magnitudes over their respective durations.
extends Node

const CHANNEL := "haptics"
const DEVICE := 0

## The haptics config resources mapping event names to rumble parameters.
@export var configs: Array[HapticsConfig] = []

## Active layers: each is {weak, strong, end_time}
var _layers: Array = []

func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_haptics_event)

func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_haptics_event)

func _on_haptics_event(payload: Dictionary) -> void:
	var event_name: String = payload.get("event_name", "")
	var entry: HapticsEntry = null
	for config in configs:
		if config == null:
			continue
		entry = config.get_entry(event_name)
		if entry != null:
			break
	if entry == null:
		return

	_layers.append({
		"weak": entry.weak_magnitude,
		"strong": entry.strong_magnitude,
		"end_time": Time.get_ticks_msec() / 1000.0 + entry.duration,
	})
	_recompute()

func _process(_delta: float) -> void:
	if _layers.is_empty():
		return
	var now := Time.get_ticks_msec() / 1000.0
	var before_count := _layers.size()
	_layers = _layers.filter(func(l): return l.end_time > now)
	if _layers.size() != before_count:
		_recompute()

func _recompute() -> void:
	if _layers.is_empty():
		Input.stop_joy_vibration(DEVICE)
		return
	var weak_sum := 0.0
	var strong_sum := 0.0
	var max_end := 0.0
	for l in _layers:
		weak_sum += l.weak
		strong_sum += l.strong
		max_end = max(max_end, l.end_time)
	weak_sum = min(weak_sum, 1.0)
	strong_sum = min(strong_sum, 1.0)
	var now := Time.get_ticks_msec() / 1000.0
	Input.start_joy_vibration(DEVICE, weak_sum, strong_sum, max_end - now)
