extends Label

@export var camera: Camera2D

func _ready() -> void:
	# position at top-left corner of the camera
	position = - (camera.get_viewport_rect().size / 2) + Vector2(100, 100)

func _process(delta: float) -> void:
	set_text("FPS %d" % Engine.get_frames_per_second())