extends Node
@onready var sound_player: AudioStreamPlayer2D = %SoundPlayer
@onready var count_down: Timer = $CountDown
@export var initial_count := 5
var _count := 0
@onready var _count_down_label: Label = %CountDownLabel
@onready var button: TextureButton = $UI/Button
@onready var texture_progress_bar: TextureProgressBar = %TextureProgressBar

func _ready() -> void:
	_count = initial_count
	_count_down_label.text = str(_count)
	
	texture_progress_bar.max_value = initial_count
	texture_progress_bar.value = _count
	button.pressed.connect(_on_button_pressed)


func _process(delta: float) -> void:
	texture_progress_bar.value = _count


func _on_count_down_timeout() -> void:
	_count -= 1
	_count = wrapi(_count, 0, initial_count + 1)
	_count_down_label.text = str(_count)



func _on_button_pressed() -> void:
	_count = initial_count
	sound_player.play()
	
	_count_down_label.text = str(_count)
	texture_progress_bar.value = _count
	count_down.start()
