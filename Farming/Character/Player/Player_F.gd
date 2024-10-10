extends CharacterBody2D

@export  var speed = 400 # How fast the player will move (pixels/sec).
@export  var movespeed:float
#@export  var movement:Grid_Movement
@onready var movement_ray = $Movement

# Called when the node enters the scene tree for the first time.
func _ready():
	$farmer_image.animation = "idle"
	$farmer_image.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$farmer_image.animation = "walk"
		$farmer_image.flip_h = velocity.x > 0
	else:
		# This might get annoying if we want to emote things like taunt...
		$farmer_image.animation = "idle"

	velocity = dir * movespeed
	if dir:
		movement_ray.target_position = velocity * 0.1
	
	move_and_slide()
	pass
