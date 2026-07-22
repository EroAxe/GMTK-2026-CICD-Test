extends Node

const CHANNEL := "screenshake"

@export var configs: Array[ScreenShakeConfig] = []
@export var camera: Camera2D

var _layers: Array = []
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_screenshake_event)

func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_screenshake_event)

func _on_screenshake_event(payload: Dictionary) -> void:
	var event_name: String = payload.get("event_name", "")
	var entry: ScreenShakeEntry = null
	for config in configs:
		if config == null:
			continue
		entry = config.get_entry(event_name)
		if entry != null:
			break
	if entry == null:
		return

	_layers.append({
		"amplitude": entry.amplitude,
		"frequency": entry.frequency,
		"end_time": Time.get_ticks_msec() / 1000.0 + entry.duration,
	})

func _process(_delta: float) -> void:
	if camera == null:
		return
	if _layers.is_empty():
		camera.offset = Vector2.ZERO
		return

	var now := Time.get_ticks_msec() / 1000.0
	_layers = _layers.filter(func(l): return l.end_time > now)

	if _layers.is_empty():
		camera.offset = Vector2.ZERO
		return

	var offset := Vector2.ZERO
	for l in _layers:
		var t: float = now * float(l.frequency)
		offset += Vector2(
			_rng.randf_range(-1.0, 1.0),
			_rng.randf_range(-1.0, 1.0)
		) * l.amplitude

	camera.offset = offset
