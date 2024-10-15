extends CharacterBody2D

@export  var speed = 400 # How fast the player will move (pixels/sec).
@export  var movespeed:float
#@export  var movement:Grid_Movement
@onready var movement_ray = $Movement

var is_sleeping = true


func _ready():
	$farmer_image.animation = "Idle"
	$farmer_image.play()


func _process(delta):
	if (is_sleeping):
		velocity = Vector2.ZERO
		return

	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$farmer_image.animation = "Walk"
		$farmer_image.speed_scale = 2.5
		$farmer_image.flip_h = velocity.x > 0
	else:
		$farmer_image.speed_scale = 1.0
		# This might get annoying if we want to emote things like taunt...
		$farmer_image.animation = "Idle"

	velocity = dir * movespeed
	if dir:
		movement_ray.target_position = velocity * 0.1
	
	move_and_slide()
	pass
