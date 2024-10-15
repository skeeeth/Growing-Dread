extends CharacterBody2D

@export var movespeed:float
@export var aiming:Aiming
@onready var interaction_raycast = $InteractionRaycast

var is_sleeping = true


func _physics_process(_delta):
	if (is_sleeping):
		return
	
	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	if dir == Vector2.ZERO:
		aiming.focused = true
	else:
		aiming.focused = false
		
	velocity = dir * movespeed
	
	if dir:
		interaction_raycast.target_position = velocity * 0.1
	
	move_and_slide()
	pass
