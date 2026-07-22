extends Control

@export var credits_config: CreditsConfig
@export var scroll_speed := 40.0

@onready var content: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var scroll: ScrollContainer = $ScrollContainer

func _ready():
	for entry in credits_config.entries:
		var label = Label.new()
		label.text = "%s - %s" % [entry.role, entry.entry_name]
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		content.add_child(label)

func _process(delta):
	scroll.scroll_vertical += scroll_speed * delta
	if scroll.scroll_vertical >= content.size.y:
		queue_free()
