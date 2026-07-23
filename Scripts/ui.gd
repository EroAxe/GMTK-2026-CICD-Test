extends Node

@onready var count_down: Timer = $CountDown

@export var initial_count := 5
var _count := 0
@onready var _count_down_label: Label = %CountDownLabel


func _ready() -> void:
	_count = initial_count
	_count_down_label.text = str(_count)


func _process(delta: float) -> void:
	pass


func _on_count_down_timeout() -> void:
	_count -= 1
	_count = wrapi(_count,0,initial_count + 1)
	_count_down_label.text = str(_count)
