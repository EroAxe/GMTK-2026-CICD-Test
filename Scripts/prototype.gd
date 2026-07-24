extends Node

@onready var count_down: Timer = $CountDown
@export var initial_count := 5
@onready var _count_down_label: Label = %CountDownLabel
@onready var button: TextureButton = $UI/Button
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar
@onready var phone_minigame: Area2D = $Phone_minigame
@onready var dialog: Control = $CanvasLayer/Dialog
@onready var animated_sprite_2d: AnimatedSprite2D = $Phone_minigame/AnimatedSprite2D
@onready var button_sound_effect: AudioStreamPlayer2D = %ButtonSoundEffect
@onready var phone_ringing: AudioStreamPlayer2D = $PhoneRinging
var _count := 0
func _ready() -> void:
	_count = initial_count
	_count_down_label.text = str(_count)
	texture_progress_bar.max_value = initial_count
	texture_progress_bar.value = _count
	button.pressed.connect(_on_button_pressed)
	trigger_phone_call()

func _process(delta: float) -> void:
	texture_progress_bar.value = _count


func _on_count_down_timeout() -> void:
	_count -= 1
	_count = wrapi(_count, 0, initial_count + 1)
	_count_down_label.text = str(_count)



func _on_button_pressed() -> void:
	_count = initial_count
	button_sound_effect.play()
	
	_count_down_label.text = str(_count)
	texture_progress_bar.value = _count
	count_down.start()

func trigger_phone_call() -> void:
	await get_tree().create_timer(5.0).timeout
	phone_ringing.play()
	animated_sprite_2d.play("ringing_with_outline")
	await get_tree().create_timer(5.0).timeout
	animated_sprite_2d.play("idle")
	phone_ringing.stop()
	dialog.show()
	dialog.show_text(0)
