extends Node2D

# Either the player needs to click the print out
# or once the printing finished we show the ui abruptly.
# currently emits a signal when the user clicks.

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var mouseOver: bool = false
@onready var printed: bool = false
@onready var signedpapers: bool = false

signal PrintedPageClicked

func _on_area_2d_mouse_entered() -> void:
	mouseOver = true
	if !printed:
		sprite.play("idle_outline")

func _on_area_2d_mouse_exited() -> void:
	mouseOver = false
	if !printed:
		sprite.play("idle")

func _on_timer_timeout() -> void:
	sprite.play("printing")
	await sprite.is_playing()
	printed = true

# currently the other canvas layers don't pass on mouse events so.... this can't work yet
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	if event_is_mouse_click and mouseOver:
		PrintedPageClicked.emit()
		print("Mouse clicked the printer")

# ment to be called once the mini-game finished to reset state.
func on_papers_signed():
	printed = false
	sprite.play("idle")
