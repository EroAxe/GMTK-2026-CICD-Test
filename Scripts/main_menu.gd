extends Node


@export var start_scene : PackedScene




func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed.call_deferred(start_scene)


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit.call_deferred()
