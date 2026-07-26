extends Area2D

@onready var switch: AnimatedSprite2D = $Switch
@onready var light_bulb: PointLight2D = %LightBulb


func _process(delta: float) -> void:
	if MiniGameManager.is_active("lightsout"):
		hide()
	else:
		show()

func _on_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()


func force_lights_out() -> void:
	switch.play("Switch_off")
	light_bulb.enabled = false

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
		
	else: 
		switch.play("switch_on")
		light_bulb.enabled = true
		
		# Restart the random countdown


func _on_blackout_timer_timeout() -> void:
	if light_bulb.enabled == true:
		force_lights_out()
