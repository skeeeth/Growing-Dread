extends CharacterBody2D

@export var movespeed:float
@export var aiming:Aiming

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	if dir == Vector2.ZERO:
		aiming.focused = true
	else:
		aiming.focused = false
		
	velocity = dir * movespeed
	move_and_slide()
	pass
