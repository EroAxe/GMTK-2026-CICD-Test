extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var dialog

var is_answered: bool = false

static var all_dialogues: Array = [0, 4, 8, 12]


static var available_dialogues: Array = []

static var last_played_index: int = -1

func _ready() -> void:
	dialog = get_tree().get_first_node_in_group("dialog")
	dialog.dialog_finished.connect(_on_dialog_finished)
	trigger_phone_call()

func _on_dialog_finished() -> void:
	print("minigame completed, do stuff here")
	animated_sprite_2d.play("idle")
	queue_free()
	EventBus.fire("minigame_completed", {"instance": self})

func trigger_phone_call() -> void:
	AudioManager.play("phone_ringing")
	animated_sprite_2d.play("ringing_with_outline")

func _on_button_pressed() -> void:

	if is_answered == true:
		return 
		

	is_answered = true 

	AudioManager.stop_sfx("phone_ringing")
	animated_sprite_2d.play("idle")
	

	if available_dialogues.is_empty():
		available_dialogues = all_dialogues.duplicate()
		available_dialogues.shuffle()
		
		if available_dialogues[0] == last_played_index and available_dialogues.size() > 1:
			var repeating_item = available_dialogues.pop_front()
			available_dialogues.push_back(repeating_item)
			

	var chosen_index: int = available_dialogues.pop_front()
	

	last_played_index = chosen_index
	
	dialog.show()
	dialog.show_text(chosen_index)
	print('press')
