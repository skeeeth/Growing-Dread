extends CharacterBody2D

@export var movespeed:float
@export var aiming:Aiming
@onready var interaction_raycast = $InteractionRaycast
@onready var sprite = $AnimatedSprite2D

var is_sleeping = true

func _physics_process(_delta):
	if (is_sleeping):
		return
	
	var dir:Vector2 = Input.get_vector("left","right","up","down")
	
	if dir == Vector2.ZERO:
		aiming.focused = true
		set_aim_animation()
	else:
		sprite.play("Walk")
		aiming.focused = false
		sprite.flip_v = false
		sprite.flip_h = dir.x > 0
	velocity = dir * movespeed
	
	if dir:
		interaction_raycast.target_position = velocity * 0.1
	
	move_and_slide()

func set_aim_animation():
	var mouse_r = get_local_mouse_position()
	if max(abs(mouse_r.x),abs(mouse_r.y)) == abs(mouse_r.x):
		sprite.play("Aim_Horizontal")
		sprite.flip_h = mouse_r.x > 0
		sprite.flip_v = false
	else:
		sprite.play("Aim_Up")
		sprite.flip_h = false
		sprite.flip_v = mouse_r.y > 0
