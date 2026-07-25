extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var printing: bool = false
@onready var signedpapers: bool = false

func _on_area_2d_mouse_entered() -> void:
	if !printing:
		sprite.stop()
		sprite.play("idle_outline")

func _on_area_2d_mouse_exited() -> void:
	if !printing:
		sprite.stop()
		sprite.play("idle")

func _on_temp_timer_timeout() -> void:
	sprite.stop()
	sprite.play("printing")
	printing = true
	# Either the player needs to click the print out
	# or once the printing finished we show the ui abruptly
	
