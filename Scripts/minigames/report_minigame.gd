extends Node2D
class_name ReportMinigame

@onready var report_label: Label = $ColorRect2/ReportLabel
var blah_count: int = 0
var max_blahs: int

func _ready() -> void:
	report_label.text = ""
	max_blahs = randf_range(50,100)
	EventBus.fire("minigame_started", {"minigame_class": ReportMinigame})

func _process(delta: float) -> void:
	if blah_count >= max_blahs:
		$ColorRect2/Submit.disabled = false
	else:
		$ColorRect2/Submit.disabled = true
	if Input.is_action_just_pressed("ui_select") and blah_count < max_blahs:
		var blahs_to_add = randi_range(2, 5)
		for i in range(blahs_to_add):
			if blah_count >= max_blahs:
				break
			report_label.text += "blah "
			blah_count += 1

func _on_submit_pressed() -> void:
	EventBus.fire("minigame_completed", {"minigame_class": ReportMinigame})
	queue_free()
