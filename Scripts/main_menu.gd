extends Node


@export var start_scene : PackedScene


func _ready() -> void:
	AudioManager.play_random_menu_music()

func _on_play_pressed() -> void:
	AudioManager.fade_out_music()
	await get_tree().create_timer(AudioManager.music_fade_duration / 2).timeout
	get_tree().change_scene_to_packed.call_deferred(start_scene)

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit.call_deferred()
