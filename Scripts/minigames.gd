extends Node2D

@onready var light_switch: Area2D = $"../LightSwitch"
@onready var phone: Area2D = $Phone_minigame
@onready var coffee: TextureButton = $"../UI/Coffee"
@onready var computer: TextureButton = $"../Computer"
@export var cool_button: TextureButton
@onready var report_notif: Sprite2D = $"../Computer/ReportNotif"

var computer_normal_tex: Texture2D

var monitor_scene
# 1.0 means 100% of normal time. 0.5 means events happen twice as fast
var difficulty_multiplier: float = 1.0

func _ready() -> void:
	monitor_scene = get_tree().get_first_node_in_group("monitor")
	computer_normal_tex = computer.texture_normal

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

	if MiniGameManager.is_active("report"):
		computer.texture_normal = computer.texture_hover
		report_notif.show()
	else:
		computer.texture_normal = computer_normal_tex
		report_notif.hide()

	if MiniGameManager.is_active("printer"):
		cool_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		cool_button.mouse_filter = Control.MOUSE_FILTER_STOP

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
			EventBus.fire("reportminigamestarted", {"instance": self})
			print("SPAWNING")
		if not MiniGameManager.is_active("lightsout"):
			MiniGameManager.spawn("lightsout", self)
			
		if not MiniGameManager.is_active("coffee"):
			MiniGameManager.spawn("coffee", self)
