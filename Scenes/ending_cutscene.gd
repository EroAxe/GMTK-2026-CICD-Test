extends Control
@onready var blackfade: ColorRect = $blackfade

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	AudioManager.stop_music()
	AudioManager.play("explosion", 0.0, 0.9)

	await get_tree().create_timer(3).timeout
	var tween = create_tween()
	tween.tween_property(blackfade,"modulate:a",1,1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_button_pressed() -> void:
	# Make sure you change this path to match your actual next scene!
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
