extends Control
signal dialog_finished

@onready var dialogue_text: Label = %Label
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer
@onready var action_buttons_v_box_container: VBoxContainer = %ActionButtonsVBoxContainer
@onready var body: TextureRect = %Body
@onready var expression: TextureRect = %Expression

@export var dialogue_items: Array[DialogueItem_step_1] = []

func _ready() -> void:
	hide_dialog()

func hide_dialog():
	hide()
	print("quit")
	dialog_finished.emit()

func show_text(current_item_index: int) -> void:
	var current_item := dialogue_items[current_item_index]
	
	dialogue_text.visible_ratio = 0.0
	dialogue_text.text = current_item.text
	
	if current_item.expression != null and current_item.expression.get_width() > 0:
		expression.texture = current_item.expression
		expression.show()
	else:
		expression.texture = null
		expression.hide()
		
	if current_item.character != null and current_item.character.get_width() > 0:
		body.texture = current_item.character
		body.show()
	else:
		body.texture = null
		body.hide()
		
	create_buttons(current_item.choices)
	
	var tween := create_tween()
	var text_appearing_duration := current_item.text.length() / 30.0
	
	tween.tween_property(dialogue_text, "visible_ratio", 1.0, text_appearing_duration)
	
	var sound_max_offset := audio_stream_player.stream.get_length() - text_appearing_duration
	var sound_start_position := randf() * sound_max_offset
	
	audio_stream_player.play(sound_start_position)
	tween.finished.connect(audio_stream_player.stop)
	
	for button: Button in action_buttons_v_box_container.get_children():
		button.disabled = true
		
	tween.finished.connect(func() -> void:
		for button: Button in action_buttons_v_box_container.get_children():
			button.disabled = false
	)

func create_buttons(choices_data: Array[DialogueChoice_step_1]) -> void:
	for button in action_buttons_v_box_container.get_children():
		button.queue_free()
		
	for choice in choices_data:
		var button := Button.new()
		action_buttons_v_box_container.add_child(button)
		button.text = choice.text
		
		if choice.is_quit == true:
			button.pressed.connect(hide_dialog)
		else:
			var target_line_idx := choice.target_line_idx
			button.pressed.connect(show_text.bind(target_line_idx))
