extends RayCast2D
class_name Aiming #DK Fighting!

@export var aim_time = 0.5;
@export var damage = 100;
@export var max_range:float

@export var  angle_max = PI/8.0
const INDICATOR_LENGTH = 200
@onready var reload = $Reload
@onready var gunshot = $Gunshot

var aim_angle:float = angle_max
var focused:bool = false;
var _previous_shot_position:Vector2 #in global space
var _previous_hit_position:Vector2 #in global space
var _shot_color:Color

func _draw():
	draw_line(_previous_shot_position-global_position,
			_previous_hit_position-global_position,
			_shot_color,
			3)
	var mouse_angle = get_local_mouse_position().angle()
	var p1 = Vector2.from_angle(mouse_angle+aim_angle) * INDICATOR_LENGTH
	var p2 = Vector2.from_angle(mouse_angle-aim_angle) * INDICATOR_LENGTH
	var c = Color.DARK_GRAY
	draw_line(Vector2.ZERO,p1,c,2)
	draw_line(Vector2.ZERO,p2,c,2)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	if focused:
		aim_angle -= angle_max * delta/aim_time
	else:
		aim_angle += (angle_max-aim_angle) * 0.1
	aim_angle = clamp(aim_angle,0.0,angle_max)
	pass
	
func _input(event):
	if event.is_action_pressed("lmb"):
		shoot()
		pass

func shoot():
	#only shoot if loaded
	if reload.time_left > 0:
		return #TODO: Feedback for prevented shots
	
	reload.start()
	
	#play sound
	gunshot.play() #NOTE: no sound currently set
	
	#Target
	var innaccuracy = randf_range(-aim_angle,aim_angle)
	var shot_angle = get_local_mouse_position().angle() + innaccuracy
	target_position = Vector2.from_angle(shot_angle) * max_range
	force_raycast_update()
	
	#Set Draw Positions
	_previous_shot_position = global_position
	if is_colliding():
		_previous_hit_position = get_collision_point()
	else:
		_previous_hit_position = target_position + global_position
	var hit_object = get_collider()
	
	#Fade flash
	_shot_color = Color.WHITE
	var fade = create_tween()
	
	fade.tween_property(self,"_shot_color",Color(Color.WHITE,0.0),0.1)
	
	#Deal Damage
	if hit_object is Hurtbox:
		hit_object.take_damage(damage)
