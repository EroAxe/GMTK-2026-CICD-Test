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
		"Countdown",
		"Meltdown",
		"Containment",
		"Radiation",
		"Coolant",
		"Turbine",
		"Core",
		"Shutdown",
		"Warning",
		"Alarm",
		"Breach",
		"Sequence",
		"Failsafe",
		"Override",
		"Sirens",
		"Evacuate",
		"Sector",
		"Diagnostics",
		"Levels",
		"Threshold",
		"Critical",
		"Fuel",
		"Rods",
		"Vent",
		"Steam",
		"Gauge",
		"Console",
		"Protocol",
		"Confirm",
		"Standby",
		"Systems",
		"Nominal",
		"Anomaly",
		"Grid"
	]
}

var word_count: int = 0
var max_words: int

func _ready() -> void:
	report_label.text = ""
	max_words = randi_range(50, 75)

func _process(delta: float) -> void:
	$ColorRect2/Submit.disabled = word_count < max_words

func _on_submit_pressed() -> void:
	EventBus.fire("minigame_completed", {"minigame_class": ReportMinigame, "instance": self})
	queue_free()

func _on_report_button_pressed() -> void:
	var words = report_words["status"]
	var words_to_add = randi_range(2, 5)

	for i in range(words_to_add):
		if word_count >= max_words:
			break

		report_label.text += words.pick_random() + " "
		word_count += 1
