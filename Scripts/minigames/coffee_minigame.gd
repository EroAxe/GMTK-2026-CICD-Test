extends Node2D

var darkness_overlay
@export var coffee_button: TextureButton

var drowsiness: float = 0.0
var drowsiness_speed: float = 0.25
var is_active: bool = true

func _ready() -> void:
	darkness_overlay = get_tree().get_first_node_in_group("darkness_overlay")
	print("Found overlay: ", darkness_overlay)
	coffee_button.z_index = 100
	darkness_overlay.material.set_shader_parameter("drowsiness", 0.0)
	coffee_button.pressed.connect(_on_coffee_pressed)
	EventBus.fire("minigame_started", {"instance": self})

func _process(delta: float) -> void:
	drowsiness += drowsiness_speed * delta
	drowsiness = clamp(drowsiness, 0.0, 1.0)
	darkness_overlay.material.set_shader_parameter("drowsiness", drowsiness)

func _on_coffee_pressed() -> void:
	drowsiness = 0.0
	darkness_overlay.material.set_shader_parameter("drowsiness", 0.0)
	_finish_minigame()

func _finish_minigame() -> void:
	EventBus.fire("minigame_completed", {"instance": self})
	queue_free()
