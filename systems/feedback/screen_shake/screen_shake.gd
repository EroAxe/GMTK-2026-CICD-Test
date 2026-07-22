## Listens for screenshake events on the event bus and applies camera
## offset shake based on a ScreenShakeConfig resource. Supports
## overlapping/simultaneous events and dynamically resolves the active
## Camera2D across scene changes.
extends Node

const CHANNEL := "screenshake"

## The screenshake config resources mapping event names to shake parameters.
@export var configs: Array[ScreenShakeConfig] = []

var _camera: Camera2D
## Active layers: each is {amplitude, frequency, end_time}
var _layers: Array = []
var _rng := RandomNumberGenerator.new()


func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_screenshake_event)
	get_tree().node_added.connect(_on_node_added)
	_find_camera()


func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_screenshake_event)


## Catches a new Camera2D entering the tree (e.g. on scene change).
func _on_node_added(node: Node) -> void:
	if node is Camera2D:
		_camera = node


## Fallback lookup for the viewport's current Camera2D.
func _find_camera() -> void:
	var vp := get_viewport()
	if vp:
		_camera = vp.get_camera_2d()


## Handles an incoming screenshake event and adds a new shake layer if a
## matching entry is found in any of [member configs].
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


## Recomputes and applies the combined camera offset from all active layers,
## pruning any that have expired.
func _process(_delta: float) -> void:
	if _camera == null:
		_find_camera()
		if _camera == null:
			return
	if _layers.is_empty():
		_camera.offset = Vector2.ZERO
		return
	var now := Time.get_ticks_msec() / 1000.0
	_layers = _layers.filter(func(l): return l.end_time > now)
	if _layers.is_empty():
		_camera.offset = Vector2.ZERO
		return
	var offset := Vector2.ZERO
	for l in _layers:
		var t: float = now * float(l.frequency)
		offset += Vector2(
			sin(t) * _rng.randf_range(-1.0, 1.0),
			cos(t) * _rng.randf_range(-1.0, 1.0)
		) * l.amplitude
	_camera.offset = offset
