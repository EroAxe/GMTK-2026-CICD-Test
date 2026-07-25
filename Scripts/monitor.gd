extends Node2D
var report_minigame_ins: PackedScene = preload("res://Scenes/minigames/report_minigame.tscn")
var report_minigame_instance: Node = null

func _on_return_button_pressed() -> void:
	hide() #hides monitor scene

func _process(delta: float) -> void:
	print(MiniGameManager.is_active("report"))
	if MiniGameManager.is_active("report"): #temporary button btw
		$spawnreportminigame.disabled = true
	else:
		$spawnreportminigame.disabled = false

func _on_spawnreportminigame_pressed() -> void:
	MiniGameManager.spawn("report", self) #spawbs reportminigame
