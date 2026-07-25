class_name SeetingsMenu extends Control

@onready var music_h_slider: HSlider = %MusicHSlider
@onready var sound_h_slider: HSlider = %SoundHSlider

var index_music_bus := AudioServer.get_bus_index("Game_music")
var index_sounds_bus := AudioServer.get_bus_index("Game_sound")
# Called when the node enters the scene tree for the first time.
@onready var go_back_button: TextureButton = $GoBackButton
func _ready() -> void:
	music_h_slider.value = AudioServer.get_bus_volume_linear(index_music_bus)
	print(music_h_slider.value)
	sound_h_slider.value = AudioServer.get_bus_volume_linear(index_sounds_bus)

	music_h_slider.value_changed.connect(
		func(value: float) -> void:
			AudioServer.set_bus_volume_db(index_music_bus, linear_to_db(value))
	)
	sound_h_slider.value_changed.connect(
		func(value: float) -> void:
			AudioServer.set_bus_volume_db(index_sounds_bus, linear_to_db(value))
	)
