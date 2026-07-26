extends Node
var num_players = 25
var bus = "Game_sound"
var music_bus = "Game_music"
var master_bus = "Master"
var available: Array[AudioStreamPlayer] = []
var queue: Array[Dictionary] = []
var active_sfx: Dictionary = {}

@export var footstep_pitch_variation := 0.1
@export var splash_pitch_variation := 0.1
@export var vocal_pitch_variation := 0.08
@export var boulder_push_pitch_variation := 0.08
@export var push_fail_pitch_variation := 0.1
@export var music_fade_duration := 1.0

var main_menu_tracks: Array[Dictionary] = [
	{
		"stream": preload("res://Assets/Music/title screen loop.wav"),
		"volume_db": 0.0,
	}
]

var in_game_tracks: Array[Dictionary] = [
	{
		"stream": preload("res://Assets/Music/jam song.mp3"),
		"volume_db": 0.0,
	},
]

var music_player: AudioStreamPlayer
var music_tween: Tween

var sfx: Dictionary = {
	"button_press": {
		"variants": [preload("res://Assets/sound_effects/button press fx.wav")],
		"category": "none",
	},
	"talking_npc": {
		"variants": [preload("res://Assets/sound_effects/talking_synth.ogg")],
		"category": "vocal",
	},
	"phone_ringing": {
		"variants": [preload("res://Assets/sound_effects/118107_ndheger_old-style-phone-ringing-rings-three-times (mp3cut.net).wav")],
		"category": "none",
	}
}

var _last_variant_index: Dictionary = {}

var ambient_player: AudioStreamPlayer

func _ready() -> void:
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		player.bus = bus
		player.finished.connect(_on_stream_finished.bind(player))
		available.append(player)
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = music_bus
	
	ambient_player = AudioStreamPlayer.new()
	add_child(ambient_player)
	ambient_player.bus = bus

var is_muted := false

func play_ambient_loop(sfx_name: String) -> void:
	if not sfx.has(sfx_name):
		return
	var stream: AudioStream = sfx[sfx_name]["variants"][0]
	if ambient_player.stream == stream and ambient_player.playing:
		return
	ambient_player.stream = stream
	ambient_player.play()

func stop_ambient_loop() -> void:
	ambient_player.stop()

func _toggle_mute() -> bool:
	is_muted = not is_muted
	_set_bus_mute(bus, is_muted)
	_set_bus_mute(music_bus, is_muted)
	_set_bus_mute(master_bus, is_muted)
	return is_muted

func _set_bus_mute(bus_name: String, muted: bool) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		push_warning("AudioManager: bus '%s' not found" % bus_name)
		return
	AudioServer.set_bus_mute(idx, muted)

func _get_pitch_variation(category: String) -> float:
	match category:
		"footstep": return footstep_pitch_variation
		"splash": return splash_pitch_variation
		"vocal": return vocal_pitch_variation
		"boulder_push": return boulder_push_pitch_variation
		"push_fail": return push_fail_pitch_variation
		_: return 0.0
func get_sfx_stream(sfx_name: String) -> AudioStream:
	if not sfx.has(sfx_name):
		push_warning("AudioManager: no sfx named '%s'" % sfx_name)
		return null
	var variants: Array = sfx[sfx_name]["variants"]
	return variants[0]

func play(sfx_name: String, volume_db: float = 0.0, start_pos: float = 0.0) -> AudioStreamPlayer:
	if not sfx.has(sfx_name):
		push_warning("AudioManager: no sfx named '%s'" % sfx_name)
		return null
	if available.is_empty():
		return null
	var data: Dictionary = sfx[sfx_name]
	var variants: Array = data["variants"]
	var index := randi() % variants.size()
	if variants.size() > 1 and _last_variant_index.get(sfx_name, -1) == index:
		index = (index + 1) % variants.size()
	_last_variant_index[sfx_name] = index
	var stream: AudioStream = variants[index]
	var pv: float = _get_pitch_variation(data.get("category", "none"))
	queue.append({"stream": stream, "pitch_variation": pv, "volume_db": volume_db, "sfx_name": sfx_name, "start_pos": start_pos})
	return _play_next()

func _play_next() -> AudioStreamPlayer:
	if available.is_empty() or queue.is_empty():
		return null
	var player = available.pop_back()
	var entry = queue.pop_front()
	player.stream = entry["stream"]
	var pv: float = entry["pitch_variation"]
	player.pitch_scale = 1.0 + randf_range(-pv, pv) if pv > 0.0 else 1.0
	player.volume_db = entry.get("volume_db", 0.0)
	active_sfx[player] = entry.get("sfx_name", "")
	player.play(entry.get("start_pos", 0.0))
	return player

func stop_sfx(sfx_name: String) -> void:
	for player in active_sfx.keys():
		if active_sfx[player] == sfx_name:
			player.stop()
			active_sfx.erase(player)
			available.append(player)

func _on_stream_finished(player: AudioStreamPlayer) -> void:
	active_sfx.erase(player)
	available.append(player)
	_play_next()

func play_random_music() -> void:
	pass

func play_random_menu_music() -> void:
	if main_menu_tracks.is_empty():
		return
	if music_tween:
		music_tween.kill()
	var track: Dictionary = main_menu_tracks[randi() % main_menu_tracks.size()]
	var stream: AudioStream = track["stream"]
	var target_volume: float = track.get("volume_db", 0.0)

	music_player.stream = stream
	music_player.volume_db = -80.0
	music_player.play()

	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", target_volume, music_fade_duration)

func play_random_ingame_music() -> void:
	if in_game_tracks.is_empty():
		return
	if music_tween:
		music_tween.kill()
	var track: Dictionary = in_game_tracks[randi() % in_game_tracks.size()]
	var stream: AudioStream = track["stream"]
	var target_volume: float = track.get("volume_db", 0.0)

	music_player.stream = stream
	music_player.volume_db = -80.0
	music_player.play()

	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", target_volume, music_fade_duration)

func stop_music() -> void:
	if music_tween:
		music_tween.kill()
	music_player.stop()

func fade_out_music() -> void:
	if music_tween:
		music_tween.kill()
	music_tween = create_tween()
	music_tween.tween_property(music_player, "volume_db", -80.0, music_fade_duration)
	music_tween.tween_callback(music_player.stop)
