extends Node2D

var report_minigame_ins: PackedScene = preload("res://Scenes/minigames/report_minigame.tscn")
var report_minigame_instance: Node = null

func _ready() -> void:
	hide()
	EventBus.subscribe("reportminigamestarted", spawn_report)

func _on_return_button_pressed() -> void:
	hide() #hides monitor scene

func spawn_report(_data = null) -> void:
	print("REPORT SPAWNED")
	MiniGameManager.spawn("report", self)
