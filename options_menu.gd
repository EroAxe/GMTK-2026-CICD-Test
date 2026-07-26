extends Control
@export var controls: Array[Control]
@export var master_volume_slider: HSlider
@export var music_volume_slider: HSlider
@export var sfx_volume_slider: HSlider

func _ready() -> void:
	master_volume_slider.value = SettingsManager.get_master_volume()
	music_volume_slider.value = SettingsManager.get_music_volume()
	if sfx_volume_slider:
		sfx_volume_slider.value = SettingsManager.get_sfx_volume()

func _on_master_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)
	_set_bus_volume(AudioManager.master_bus, value)
	SettingsManager.save_settings()

func _on_music_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)
	_set_bus_volume(AudioManager.music_bus, value)
	SettingsManager.save_settings()

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)
	_set_bus_volume(AudioManager.bus, value)
	SettingsManager.save_settings()

func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		push_warning("SettingsMenu: bus '%s' not found" % bus_name)
		return
	AudioServer.set_bus_volume_db(idx, linear_to_db(linear_value))

func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
