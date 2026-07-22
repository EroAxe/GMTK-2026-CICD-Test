extends Control

@export var credits_config: CreditsConfig
@export var scroll_speed := 40.0
@export var header_font: Font
@export var header_font_size := 28
@export var name_font_size := 20
@export var spacing_between_roles := 24

@onready var content: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var scroll: ScrollContainer = $ScrollContainer

func _ready():
	var grouped: Dictionary = {}
	for entry in credits_config.entries:
		if not grouped.has(entry.role):
			grouped[entry.role] = []
		grouped[entry.role].append(entry.entry_name)

	var roles = grouped.keys()
	roles.sort()

	for i in roles.size():
		var role = roles[i]

		var role_label = Label.new()
		role_label.text = role
		role_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if header_font:
			role_label.add_theme_font_override("font", header_font)
		role_label.add_theme_font_size_override("font_size", header_font_size)
		content.add_child(role_label)

		var underline = ColorRect.new()
		underline.color = Color.WHITE
		underline.custom_minimum_size = Vector2(100, 2)
		underline.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		content.add_child(underline)

		var names = grouped[role]
		names.sort()

		for entry_name in names:
			var name_label = Label.new()
			name_label.text = entry_name
			name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			name_label.add_theme_font_size_override("font_size", name_font_size)
			content.add_child(name_label)

		if i < roles.size() - 1:
			var spacer = Control.new()
			spacer.custom_minimum_size = Vector2(0, spacing_between_roles)
			content.add_child(spacer)

func _process(delta):
	scroll.scroll_vertical += scroll_speed * delta
	if scroll.scroll_vertical >= content.size.y:
		queue_free()
