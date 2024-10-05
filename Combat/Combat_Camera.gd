extends Camera2D

@onready var crt_overlay = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	crt_overlay.size = get_viewport_rect().size
	crt_overlay.position = -crt_overlay.size/2.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
