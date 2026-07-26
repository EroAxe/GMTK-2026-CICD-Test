extends Node2D
@onready var light_switch: Area2D = $"../LightSwitch"
@onready var phone: Area2D = $Phone_minigame
@onready var coffee: TextureButton = $"../UI/Coffee"

func _ready() -> void:
	_loop_minigame("coffee", 5.0, 30.0)
	_loop_minigame("lightsout", 15.0, 30.0)
	_loop_minigame("phone", 15.0, 30.0)

func _process(delta: float) -> void:
	if MiniGameManager.is_active("coffee"):
		coffee.hide()
	else:
		coffee.show()
	if MiniGameManager.is_active("lightsout"):
		light_switch.hide()
	else:
		light_switch.show()
	if MiniGameManager.is_active("phone"):
		phone.hide()
	else:
		phone.show()

func _loop_minigame(minigame_name: String, min_wait: float, max_wait: float) -> void:
	while true:
		await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
		if not is_instance_valid(self):
			return
		if not MiniGameManager.is_active(minigame_name):
			MiniGameManager.spawn(minigame_name, self)
