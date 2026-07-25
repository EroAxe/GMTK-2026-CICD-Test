extends Node
var active_minigames: Dictionary = {} 

#add your mini game scenes here.
var minigame_scenes := {
	"report": preload("res://Scenes/minigames/report_minigame.tscn")
} 

func _ready() -> void:
	EventBus.subscribe("minigame_completed", _on_completed) #listens to minigames that have been completed

func spawn(minigame_id: String, parent: Node) -> Node:
	#spawns the mini games via MiniGameManager.spawn("report", self) as example.
	if not minigame_scenes.has(minigame_id):
		push_error("Unknown minigame: %s" % minigame_id)
		return null
	var instance = minigame_scenes[minigame_id].instantiate()
	parent.add_child(instance)
	active_minigames[minigame_id] = instance
	return instance

func _on_completed(payload: Dictionary) -> void:
	#when mini games are completed they are removed from active_minigames
	if payload.has("instance"):
		for id in active_minigames.keys():
			if active_minigames[id] == payload["instance"]:
				active_minigames.erase(id)
				break

func is_active(minigame_id: String) -> bool:
	#checks if any SPECIFIC minigames are active/started. example of use 	if MiniGameManager.is_active("report"): 		$spawnreportminigame.disabled = true 	else: 		$spawnreportminigame.disabled = false
	if not active_minigames.has(minigame_id):
		return false
	if not is_instance_valid(active_minigames[minigame_id]):
		active_minigames.erase(minigame_id)
		return false
	return true

func any_active() -> bool:
	#check if ANY MINIGAMES are currently active. example of use $UI/Button.disabled = MiniGameManager.any_active() - if true it disables it and if false it enables it.
	for id in active_minigames.keys():
		if is_active(id):
			return true
	return false
