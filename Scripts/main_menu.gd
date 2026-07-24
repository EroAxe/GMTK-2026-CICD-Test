extends Node


@export var start_scene : PackedScene




func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed.call_deferred(start_scene)


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/setting_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit.call_deferred()
