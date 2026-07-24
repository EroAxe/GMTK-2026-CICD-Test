extends Node2D
class_name ReportMinigame

@onready var report_label: Label = $ColorRect2/ReportLabel

var report_words := {
	"status": [
		"Operational",
		"Stable",
		"Cooling",
		"Pressure",
		"Reactor",
		"Temperature",
		"Inspection",
		"Maintenance",
		"Routine",
		"Complete",
		"Report",
		"Countdown"
	]
}

var word_count: int = 0
var max_words: int

func _ready() -> void:
	report_label.text = ""
	max_words = randi_range(25, 50)
	EventBus.fire("minigame_started", {"minigame_class": ReportMinigame})

func _process(delta: float) -> void:
	$ColorRect2/Submit.disabled = word_count < max_words

func _on_submit_pressed() -> void:
	EventBus.fire("minigame_completed", {"minigame_class": ReportMinigame})
	queue_free()

func _on_report_button_pressed() -> void:
	var words = report_words["status"]
	var words_to_add = randi_range(2, 5)

	for i in range(words_to_add):
		if word_count >= max_words:
			break

		report_label.text += words.pick_random() + " "
		word_count += 1
