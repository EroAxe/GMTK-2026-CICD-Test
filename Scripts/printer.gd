extends Node2D

@onready var printer_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var printer_outline_sprite: Sprite2D = $Sprite2D

@onready var printer_timer: Timer = $Timer
@export var minimum_printer_time: float = 4.0
@export var maximum_printer_time: float = 10.0

var mouseOver: bool = false
var printed: bool = false

signal PrintedPageClicked

func _ready() -> void:
	start_timer()

func _on_area_2d_mouse_entered() -> void:
	mouseOver = true
	printer_outline_sprite.show()

func _on_area_2d_mouse_exited() -> void:
	mouseOver = false
	printer_outline_sprite.hide()

func _on_timer_timeout() -> void:
	printer_sprite.play("printing")
	await printer_sprite.animation_finished
	MiniGameManager.notify_started("printer", self)
	printed = true

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	if event_is_mouse_click and mouseOver and printed:
		PrintedPageClicked.emit()
		print("Mouse clicked the printer")

func start_timer() -> void:
	# Pick a random number of seconds
	var random_time = randf_range(minimum_printer_time, maximum_printer_time)
	# Start the timer with random time number
	printer_timer.start(random_time)

func _on_printed_page_page_signed() -> void:
	EventBus.fire("minigame_completed", {"instance": self})
	printed = false
	printer_sprite.play("idle")
	start_timer()
