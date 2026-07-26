extends Sprite2D

@export var default_texture: Texture2D
@export var clicked_texture: Texture2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	if default_texture != null:
		texture = default_texture

# We changed delta to _delta so Godot doesn't warn you about an unused variable!
func _physics_process(_delta: float) -> void:
	# 1. Snap instantly to the mouse position
	global_position = get_global_mouse_position()
	
	var is_clicking: bool = Input.is_action_pressed("click")
	
	# 2. Instant rotation (No lerp)
	rotation_degrees = -12.5 if is_clicking else 0.0

	# 3. Instant scale/squish (No lerp)
	scale = Vector2(2.5, 2.5) if is_clicking else Vector2(3.0, 3.0)
	
	# 4. Instant texture swap
	if is_clicking and clicked_texture != null:
		texture = clicked_texture
	elif not is_clicking and default_texture != null:
		texture = default_texture
