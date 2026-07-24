extends Node2D
var report_minigame_ins: PackedScene = preload("res://Scenes/minigames/report_minigame.tscn")
var report_minigame_instance: Node = null

func _on_return_button_pressed() -> void:
	hide()

func _process(delta: float) -> void:
	if is_instance_valid(report_minigame_instance):
		$spawnreportminigame.disabled = true
	else:
		$spawnreportminigame.disabled = false

func _on_spawnreportminigame_pressed() -> void:
	if is_instance_valid(report_minigame_instance):
		return
	report_minigame_instance = report_minigame_ins.instantiate()
	add_child(report_minigame_instance)
