@tool
class_name PauseMenu extends Control

@onready var _blur_color_rect: ColorRect = %BlurColorRect
@onready var _ui_panel_container: PanelContainer = %UIPanelContainer
@export_range(0, 1.0) var menu_opened_amount := 0.0:
	set = set_menu_opened_amount

## How fast the pause menu opens
@export_range(0.1, 10.0, 0.01, "or_greater") var animation_duration := 2.3

var _tween: Tween

var _is_currently_opening := false


@onready var resume: Button = %Play
@onready var options: Button = %Options
@onready var exit: Button = %Exit


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	menu_opened_amount = 0.0

	# The resume button is now handled entirely by your MenuController
	exit.pressed.connect(get_tree().quit)


## Called when [member menu_opened_amount] is changed.
func set_menu_opened_amount(amount: float) -> void:
	menu_opened_amount = amount
	visible = amount > 0.0
	
	# we ensure the nodes exist (in case the function gets called before _ready)
	if _ui_panel_container == null or _blur_color_rect == null:
		return
		
	# we lerp all the values between 0 and 1, the two regular extremes of the
	# menu_opened_amount variable.
	# first, the shader. We set the blur amount and the saturation
	_blur_color_rect.material.set_shader_parameter("blur_amount", lerp(0.0, 1.5, amount))
	_blur_color_rect.material.set_shader_parameter("saturation", lerp(1.0, 0.3, amount))
	_blur_color_rect.material.set_shader_parameter("tint_strength", lerp(0.0, 0.2, amount))
	_ui_panel_container.modulate.a = amount
	
	# The game pause state is now handled entirely by your MenuController
	
	# Only allow interaction when the menu is 99%+ open
	# This disables the buttons entirely while it is fading IN and fading OUT
	var can_interact = (amount > 0.99)
	var m_filter = Control.MOUSE_FILTER_STOP if can_interact else Control.MOUSE_FILTER_IGNORE
	var f_mode = Control.FOCUS_ALL if can_interact else Control.FOCUS_NONE
	
	resume.mouse_filter = m_filter
	resume.focus_mode = f_mode
	options.mouse_filter = m_filter
	options.focus_mode = f_mode
	exit.mouse_filter = m_filter
	exit.focus_mode = f_mode

func toggle(is_toggled: bool = not _is_currently_opening) -> void:
	_is_currently_opening = is_toggled
	var target_amount := 1.0 if _is_currently_opening else 0.0

	if _tween != null:
		_tween.kill()

	if _is_currently_opening:
		var duration := absf(target_amount - menu_opened_amount) * animation_duration
		_tween = create_tween()
		_tween.set_ease(Tween.EASE_OUT)
		_tween.set_trans(Tween.TRANS_QUART)
		_tween.tween_property(self, "menu_opened_amount", target_amount, duration)
	else:
		menu_opened_amount = target_amount

func hide_buttons() -> void:
	_ui_panel_container.hide()


func show_buttons() -> void:
	_ui_panel_container.show()
