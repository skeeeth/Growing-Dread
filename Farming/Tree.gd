extends Area2D
class_name EyeTree

@export var forward_margin:float = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	$tree_image.animation = "Look_Straight"
	$tree_image.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#look_at_position(get_global_mouse_position())
	pass

func look_at_position(pos:Vector2): #in global position
	if global_position.x - pos.x > 100:
		$tree_image.play("Look_Left")
	elif global_position.x - pos.x < -100:
		$tree_image.play("Look_Right")
	else:
		$tree_image.play("Look_Straight")
