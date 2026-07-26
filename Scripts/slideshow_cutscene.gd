extends Control


@export var slides: Array[Texture2D]


@export var fade_duration: float = 1.0
@export var read_time: float = 5.0

@onready var texture_rect: TextureRect = $ColorRect/TextureRect

func _ready():

	texture_rect.modulate.a = 0
	
	play_slideshow()

func play_slideshow():
	for slide in slides:
		# change image
		texture_rect.texture = slide
		
		# 2. Fade In
		var tween = create_tween()
		tween.tween_property(texture_rect, "modulate:a", 1.0, fade_duration)
		await tween.finished 
		
		await get_tree().create_timer(read_time).timeout
		
		tween = create_tween()
		tween.tween_property(texture_rect, "modulate:a", 0.0, fade_duration)
		await tween.finished 


	print("Slideshow complete")
	
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
