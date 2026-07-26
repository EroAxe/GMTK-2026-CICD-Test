extends Node

const SETTINGS_PATH := "user://settings.cfg"

var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0

func get_master_volume() -> float:
	return master_volume

func set_master_volume(value: float) -> void:
	master_volume = value

func get_music_volume() -> float:
	return music_volume

func set_music_volume(value: float) -> void:
	music_volume = value

func get_sfx_volume() -> float:
	return sfx_volume

func set_sfx_volume(value: float) -> void:
	sfx_volume = value

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume)
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		return
	master_volume = config.get_value("audio", "master_volume", 1.0)
	music_volume = config.get_value("audio", "music_volume", 1.0)
	sfx_volume = config.get_value("audio", "sfx_volume", 1.0)

func _ready() -> void:
	load_settings()
	apply_audio_settings()
