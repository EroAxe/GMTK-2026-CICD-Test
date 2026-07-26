extends Node

@onready var count_down: Timer = $CountDown
@export var initial_count := 30
@export var cool_count := 5
@onready var _count_down_label: Label = %CountDownLabel
@onready var button: TextureButton = $UI/Button
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var phone_minigame: Area2D = $Phone_minigame
@onready var dialog: Control = $CanvasLayer/Dialog
@onready var animated_sprite_2d: AnimatedSprite2D = $Minigames/Phone_minigame/AnimatedSprite2D
@onready var button_sound_effect: AudioStreamPlayer2D = %ButtonSoundEffect
@onready var phone_ringing: AudioStreamPlayer2D = $PhoneRinging
@onready var light_bulb: PointLight2D = $LightBulb

var _count := 0

#minigames
var monitor_instance: Node = null
var monitor_scene_ins: PackedScene = preload("res://Scenes/monitor.tscn")

func _ready() -> void:
	_count = initial_count
	_count_down_label.text = str(_count)
	texture_progress_bar.max_value = initial_count
	texture_progress_bar.value = _count
	button.pressed.connect(_on_button_pressed)
	trigger_phone_call()

	AudioManager.play_random_ingame_music()

func _process(delta: float) -> void:
	texture_progress_bar.value = _count
	print(MiniGameManager.any_active()) #debug print for when any miningames are active.
	$UI/Button.disabled = MiniGameManager.any_active() #there are minigames running = disabled

func _on_count_down_timeout() -> void:
	_count -= 1
	_count = wrapi(_count, 0, initial_count + 1)
	_count_down_label.text = str(_count)

func _on_button_pressed() -> void:
	_count = clamp(_count + cool_count, 0, initial_count)
	AudioManager.play("button_press")
	_count_down_label.text = str(_count)
	texture_progress_bar.value = _count
	count_down.start()

func trigger_phone_call() -> void:
	await get_tree().create_timer(5.0).timeout
	AudioManager.play("phone_ringing")
	animated_sprite_2d.play("ringing_with_outline")
	await get_tree().create_timer(5.0).timeout
	animated_sprite_2d.play("idle")
	AudioManager.stop_sfx("phone_ringing")
	dialog.show()
	dialog.show_text(0)

func _on_computer_pressed() -> void:
	if monitor_instance != null and is_instance_valid(monitor_instance):
		monitor_instance.show() #if the monitor is already added then just show it, because when u return it hides it.
		return
	monitor_instance = monitor_scene_ins.instantiate()
	add_child(monitor_instance)


func _on_spawncoffeeminigame_pressed() -> void:
	MiniGameManager.spawn("coffee",self)


func _on_spawnlightsout_pressed() -> void:
	MiniGameManager.spawn("lightsout",self)
