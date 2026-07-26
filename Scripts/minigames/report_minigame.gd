extends Node2D
class_name ReportMinigame

@onready var report_label: Label = $ColorRect2/ReportLabel
@onready var submit_button: Button = $ColorRect2/Submit

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
} #random words to be used when filling up report

var word_count: int = 0
var max_words: int

func _ready() -> void:
	report_label.text = ""
	max_words = 50 #maximum words to be able to submit

func _process(delta: float) -> void:
	if word_count == max_words:  #if max words = enable
		EventBus.fire("minigame_completed", {"instance": self})
		queue_free() #free the minigame

func _on_report_button_pressed() -> void:
	var words = report_words["status"] #words in status key
	var words_to_add = randi_range(2, 5) #random X of words to add per click

	for i in range(words_to_add):
		if word_count >= max_words:
			break

		report_label.text += words.pick_random() + " "
		word_count += 1
