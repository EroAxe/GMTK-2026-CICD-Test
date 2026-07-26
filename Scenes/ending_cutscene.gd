extends Control

@onready var button: Button = %Button
@onready var label: Label = %Label
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	AudioManager.stop_music()
	AudioManager.play("explosion", 0.0, 0.9)
	button.hide()
	label.hide()

	animated_sprite_2d.animation_finished.connect(_on_animation_finished)

	button.pressed.connect(_on_button_pressed)

func _on_animation_finished() -> void:
	button.show()
	label.show()


func _on_button_pressed() -> void:
	# Make sure you change this path to match your actual next scene!
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
