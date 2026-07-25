extends Area2D

@onready var switch: AnimatedSprite2D = $Switch
@onready var light_bulb: PointLight2D = %LightBulb

@onready var blackout_timer: Timer = %blackout_timer


@export var main_button: TextureButton 


@export var minimum_light_time: float = 5.0
@export var maximum_light_time: float = 15.0


func _ready() -> void:

	start_random_blackout()


func start_random_blackout() -> void:
	# Pick a random number of seconds
	var random_time = randf_range(minimum_light_time, maximum_light_time)
	# Start the timer with random time number
	blackout_timer.start(random_time)



func _on_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()


func force_lights_out() -> void:
	switch.play("Switch_off")
	light_bulb.enabled = false
	main_button.disabled = true

#mouse click
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)

	if event_is_mouse_click:
		toggle_switch()


func toggle_switch() -> void:
	
	if light_bulb.enabled == true:
		force_lights_out()
		blackout_timer.stop() 
		
	else: 
		switch.play("switch_on")
		light_bulb.enabled = true
		main_button.disabled = false
		
		# Restart the random countdown
		start_random_blackout()


func _on_blackout_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()
