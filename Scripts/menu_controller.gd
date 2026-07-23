extends Control

@onready var _pause_menu: PauseMenu = $PauseScreen
@onready var _settings_menu: SeetingsMenu = $SettingMenu



func _ready() -> void:
	_pause_menu.options.pressed.connect(func () -> void:
		_settings_menu.show()
		_pause_menu.hide_buttons()
	)
	_settings_menu.go_back_button.pressed.connect(func () -> void:
		_settings_menu.hide()
		_pause_menu.show_buttons()
	)
	_pause_menu.resume.pressed.connect(
		toggle_pause.bind(false)
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause(not get_tree().paused)


func toggle_pause(new_state: bool) -> void:
	get_tree().paused = new_state
	_settings_menu.hide()
	_pause_menu.toggle(new_state)
