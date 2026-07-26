extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var dialog

func _ready() -> void:
	dialog = get_tree().get_first_node_in_group("dialog")
	trigger_phone_call()

func trigger_phone_call() -> void:
	AudioManager.play("phone_ringing")
	animated_sprite_2d.play("ringing_with_outline")

func _on_button_pressed() -> void:
	animated_sprite_2d.play("idle")
	dialog.show()
	dialog.show_text(0)
	print('press')
