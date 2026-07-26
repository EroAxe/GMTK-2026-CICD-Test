extends Node2D

signal page_signed

@onready var page = $AnimatedSprite2D
@onready var timer = $Timer

func _on_printer_printed_page_clicked() -> void:
	page.show()

func _on_area_2d_input_event(viewport, event: InputEvent, shape) -> void:
	if !page.visible:
		return
	
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	)
	if event_is_mouse_click:
		page.play("signed")
		timer.start(0.5)
		await timer.timeout
		page.play("unsigned")
		page.hide()
		page_signed.emit()
