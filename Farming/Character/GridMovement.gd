## Grid based movement lerping and collision validation
##
extends RayCast2D
class_name Grid_Movement

signal movement_finished(direction)

@export var tile_size:float
@export var parent:Node2D
var moving:bool = false
var start_position 

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = parent.position
	Farming.day_progressed.connect(reset_position)

func reset_position():
	parent.position = start_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#checks 
func check_move(movement:Vector2)->String:
	target_position = movement * tile_size
	force_raycast_update()
	if moving: return "moving"
	if is_colliding(): return "c" #for collision
	return ""

func move(dir:Vector2,time:float):
	moving = true
	var tween = create_tween()
	var targetPosition = dir * tile_size
	tween.tween_property(parent,"position",
		parent.position + targetPosition,
		time)
	await  tween.finished
	moving = false
	movement_finished.emit(dir)
