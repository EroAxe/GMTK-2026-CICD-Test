extends Node2D

@onready var light_switch: Area2D = $"../LightSwitch"
@onready var phone: Area2D = $Phone_minigame
@onready var coffee: TextureButton = $"../UI/Coffee"

# 1.0 means 100% of normal time. 0.5 means events happen twice as fast
var difficulty_multiplier: float = 1.0 

func _ready() -> void:
	
	_loop_minigame("coffee", 15.0, 45.0)
	_loop_minigame("lightsout", 15.0, 45.0)
	_loop_minigame("phone", 10.0, 40.0) 
	
	# Start Report Combo loop
	_loop_report_combo(30.0, 60.0) 

func _process(delta: float) -> void:
	# DIFFICULTY SCALING
	difficulty_multiplier = move_toward(difficulty_multiplier, 0.3, delta * 0.002)
	
	#UI VISIBILITY
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

# Loop for individual minigames
func _loop_minigame(minigame_name: String, min_wait: float, max_wait: float) -> void:
	while true:
		while MiniGameManager.is_active(minigame_name):
			await get_tree().create_timer(1.0).timeout
			
		# startcooldown timer for the next spawn
		var wait_time = randf_range(min_wait, max_wait) * difficulty_multiplier
		await get_tree().create_timer(wait_time).timeout
		
		if not is_instance_valid(self):
			return
			
		if not MiniGameManager.is_active(minigame_name):
			MiniGameManager.spawn(minigame_name, self)

# Loop for the Report Combo
func _loop_report_combo(min_wait: float, max_wait: float) -> void:
	while true:
		#Wait untit report minigame is completely cleared
		while MiniGameManager.is_active("report"):
			await get_tree().create_timer(1.0).timeout
			
		var wait_time = randf_range(min_wait, max_wait) * difficulty_multiplier
		await get_tree().create_timer(wait_time).timeout
		
		if not is_instance_valid(self):
			return
		
		if not MiniGameManager.is_active("report"):
			MiniGameManager.spawn("report", self)
			
		if not MiniGameManager.is_active("lightsout"):
			MiniGameManager.spawn("lightsout", self)
			
		if not MiniGameManager.is_active("coffee"):
			MiniGameManager.spawn("coffee", self)
