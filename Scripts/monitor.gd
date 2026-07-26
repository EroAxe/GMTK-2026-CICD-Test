extends Node2D

var report_minigame_ins: PackedScene = preload("res://Scenes/minigames/report_minigame.tscn")
var report_minigame_instance: Node = null

func _ready() -> void:
	_loop_minigame()

func _on_return_button_pressed() -> void:
	hide() #hides monitor scene

func _process(delta: float) -> void:
	print(MiniGameManager.is_active("report"))

func _loop_minigame() -> void:
	while true:
		var wait_time := randf_range(20.0, 35.0)
		print("Waiting %s seconds before next report spawn attempt" % wait_time)
		await get_tree().create_timer(wait_time).timeout
		if not is_instance_valid(self):
			return
		if MiniGameManager.is_active("report"):
			print("Report already active, skipping spawn")
		else:
			print("Spawning report minigame")
			MiniGameManager.spawn("report", self)
