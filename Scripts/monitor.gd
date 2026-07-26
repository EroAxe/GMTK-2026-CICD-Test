extends Node2D

var report_minigame_ins: PackedScene = preload("res://Scenes/minigames/report_minigame.tscn")
var report_minigame_instance: Node = null



func _on_return_button_pressed() -> void:
	hide() #hides monitor scene

func _process(delta: float) -> void:
	print(MiniGameManager.is_active("report"))
