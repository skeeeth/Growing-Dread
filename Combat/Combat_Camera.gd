extends Camera2D

@onready var crt_overlay = $ColorRect
@export var tracked_object:Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	crt_overlay.size = get_viewport_rect().size
	crt_overlay.position = -crt_overlay.size/2.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = ((tracked_object.global_position * 3.0) + get_global_mouse_position())/4.0;
	crt_overlay.global_position = get_screen_center_position() - crt_overlay.size/2.0
	pass
