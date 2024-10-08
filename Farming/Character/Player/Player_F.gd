extends CharacterBody2D

@export var movespeed:float
@onready var movement_ray = $Movement

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	velocity = dir * movespeed
	if dir:
		movement_ray.target_position = velocity * 0.1
	
	move_and_slide()
	pass
