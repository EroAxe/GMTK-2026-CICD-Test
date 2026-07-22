## Listens for screenflash events on the event bus and fades a full-screen
## ColorRect overlay based on a ScreenFlashConfig resource. Overlapping
## events take the highest alpha rather than combining.
extends Node

const CHANNEL := "screenflash"
const OVERLAY_GROUP := "screen_flash_overlay"

## The screen flash config resources mapping event names to flash parameters.
@export var configs: Array[ScreenFlashConfig] = []

var _overlay: ColorRect
var _color: Color = Color(1, 1, 1, 0)
var _start_time: float = 0.0
var _duration: float = 0.0
var _active: bool = false


func _ready() -> void:
	EventBus.subscribe(CHANNEL, _on_screenflash_event)
	get_tree().node_added.connect(_on_node_added)
	_find_overlay()


func _exit_tree() -> void:
	EventBus.unsubscribe(CHANNEL, _on_screenflash_event)


## Catches a new overlay ColorRect entering the tree (e.g. on scene change).
func _on_node_added(node: Node) -> void:
	if node is ColorRect and node.is_in_group(OVERLAY_GROUP):
		_overlay = node


## Fallback lookup for the current overlay ColorRect.
func _find_overlay() -> void:
	var node := get_tree().get_first_node_in_group(OVERLAY_GROUP)
	if node is ColorRect:
		_overlay = node


## Handles an incoming screenflash event and starts the flash if a
## matching entry is found in any of [member configs].
func _on_screenflash_event(payload: Dictionary) -> void:
	var event_name: String = payload.get("event_name", "")
	var entry: ScreenFlashEntry = null
	for config in configs:
		if config == null:
			continue
		entry = config.get_entry(event_name)
		if entry != null:
			break
	if entry == null:
		return

	_color = entry.color
	_duration = entry.duration
	_start_time = Time.get_ticks_msec() / 1000.0
	_active = true


## Fades the overlay alpha from the entry's peak down to 0 over duration.
func _process(_delta: float) -> void:
	if _overlay == null:
		_find_overlay()
		if _overlay == null:
			return
	if not _active:
		return
	var now := Time.get_ticks_msec() / 1000.0
	var t := (now - _start_time) / _duration if _duration > 0.0 else 1.0
	if t >= 1.0:
		_overlay.color = Color(_color.r, _color.g, _color.b, 0.0)
		_active = false
		return
	var alpha: float = lerp(_color.a, 0.0, t)
	_overlay.color = Color(_color.r, _color.g, _color.b, alpha)
