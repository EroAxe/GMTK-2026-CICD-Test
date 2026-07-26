extends Node2D

@onready var switch: AnimatedSprite2D = $Switch
@onready var light_bulb

@export var minimum_light_time: float = 5.0
@export var maximum_light_time: float = 15.0


func _ready() -> void:
	light_bulb = get_tree().get_first_node_in_group("light_bulb")
	force_lights_out()

	print(light_bulb)

func start_random_blackout() -> void:
	# Pick a random number of seconds
	var random_time = randf_range(minimum_light_time, maximum_light_time)
	# Start the timer with random time number



func _on_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()


func force_lights_out() -> void:
	light_bulb.enabled = false

func toggle_switch() -> void:
	
	if light_bulb.enabled == true:
		force_lights_out()
	else: 
		light_bulb.enabled = true
		# Restart the random countdown
		EventBus.fire("minigame_completed", {"instance": self})
		queue_free()


func _on_blackout_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()

func _on_switch_pressed() -> void:
	toggle_switch()
