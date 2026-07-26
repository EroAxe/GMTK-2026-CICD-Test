extends Node

@onready var count_down: Timer = $CountDown
@export var initial_count := 30
@export var cool_count := 2
@onready var _count_down_label: Label = %CountDownLabel
@onready var button: TextureButton = $UI/Button
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var phone_minigame: Area2D = $Phone_minigame
@onready var dialog: Control = $CanvasLayer/Dialog
@onready var button_sound_effect: AudioStreamPlayer2D = %ButtonSoundEffect
@onready var phone_ringing: AudioStreamPlayer2D = $PhoneRinging
@onready var light_bulb: PointLight2D = $LightBulb

var _count := 0
var button_tween: Tween
var button_original_scale: Vector2 

#minigames
var monitor_instance: Node = null
var monitor_scene_ins: PackedScene = preload("res://Scenes/monitor.tscn")

func _ready() -> void:
	_count = initial_count
	_count_down_label.text = str(_count)
	texture_progress_bar.max_value = initial_count
	texture_progress_bar.value = _count
	button.pressed.connect(_on_button_pressed)
	
	button_original_scale = button.scale
	button.pivot_offset = button.size / 2.0

	AudioManager.play_random_ingame_music()

	monitor_instance = monitor_scene_ins.instantiate()
	monitor_instance.add_to_group("monitor")
	add_child(monitor_instance)
	monitor_instance.hide()

func _process(delta: float) -> void:
	texture_progress_bar.value = _count
	
	# RESTORED: This line properly disables the button when a minigame is active
	$UI/Button.disabled = MiniGameManager.any_active() 

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
	
	# TWEEN SQUASH ANIMATION
	if button_tween and button_tween.is_valid():
		button_tween.kill()
		
	button.scale = button_original_scale
	
	button_tween = create_tween()
	var squashed_size = button_original_scale * Vector2(1.2, 0.8)
	button_tween.tween_property(button, "scale", squashed_size, 0.05)
	button_tween.tween_property(button, "scale", button_original_scale, 0.15).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

func _on_computer_pressed() -> void:
	if monitor_instance != null and is_instance_valid(monitor_instance):
		monitor_instance.show() 
		return
	monitor_instance = monitor_scene_ins.instantiate()
	add_child(monitor_instance)
