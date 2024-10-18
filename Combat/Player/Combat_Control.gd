extends CharacterBody2D
class_name Combat_Control

@export var movespeed:float
@export var aiming:Aiming
@onready var interaction_raycast = $InteractionRaycast
@onready var sprite = $AnimatedSprite2D

var torch_radius:float = 200
var torch_radius_decay_rate:float = 0
var minimum_torch_radius:float = 100
var torch_light_texture_scale_to_radius_ratio = 1.3/150 #found through testing

var is_sleeping = true

var damage_screen_cover_opacity = 0
var damage_screen_cover_opacity_decay_rate = 1

	
#func _ready():
#	torch_light_texture_scale_to_radius_ratio = $TorchLight.texture_scale / torch_radius 

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
	
	if (torch_radius_decay_rate > 0 and torch_radius > minimum_torch_radius):
		torch_radius = max(minimum_torch_radius, torch_radius - (torch_radius_decay_rate * _delta))
		$TorchLight.texture_scale = torch_radius * torch_light_texture_scale_to_radius_ratio
		
		if (torch_radius <= minimum_torch_radius):
			$TorchExtinguishTimer.start(5)
			#To-do: make the monsters kill the player when the torch goes out; display game over screen
	
	if (damage_screen_cover_opacity > 0):
		damage_screen_cover_opacity = clampf(damage_screen_cover_opacity - (damage_screen_cover_opacity_decay_rate * _delta), 0, 1)
		$DamageScreenCover.modulate = Color(1, 0, 0, damage_screen_cover_opacity)

func _on_torch_extinguish_timer_timeout():
	$TorchLight.energy = 0
	torch_radius = -1

func take_damage(amount):
	damage_screen_cover_opacity += 0.3
	#To-do: actually track health and kill the player when it reaches zero
	#could immobilize them by setting is_sleeping=true
	#then after a delay, show a game over screen

func set_aim_animation():
	var mouse_r = get_local_mouse_position()
	if max(abs(mouse_r.x),abs(mouse_r.y)) == abs(mouse_r.x):
		sprite.play("Aim_Horizontal")
		sprite.flip_h = mouse_r.x > 0
		sprite.flip_v = false
	#else:
		#sprite.play("Aim_Up")
		#sprite.flip_h = false
		#sprite.flip_v = mouse_r.y > 0
