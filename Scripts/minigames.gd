extends Node2D
@onready var light_switch: Area2D = $"../LightSwitch"
@onready var phone: Area2D = $Phone_minigame
@onready var coffee: TextureButton = $"../UI/Coffee"


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
