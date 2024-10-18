extends Node2D
class_name ParentFire

var growth_time = 6

var min_num_spreads = 2
var max_num_spreads = 3

var min_spread_distance = 30
var max_spread_distance = 40

@export var testing:bool = false

@onready var child_fire_scene = preload("res://not_cursed_fire.tscn")

func _ready():
	global_position = Vector2(200, 200)
	my_init()


func my_init():
	$MySprite/AnimationPlayer.play("fire_flicker")
	
	create_tween().tween_property($MySprite,"scale",Vector2(4,4),growth_time) 
	await get_tree().create_timer(growth_time).timeout
	for i in 4:
		spread(Vector2.from_angle(i * (TAU/4)))


func spread(_spread_direction):
	print("Called spread() with this arg: " + str(_spread_direction))
	var num_new_fires = randi_range(min_num_spreads, max_num_spreads)
	
	#Each new fire should spread in spread_direction, plus or minus up to 45 degrees
	#So let's start at -45 degrees...
	var current_spread_direction = _spread_direction.rotated(-PI/4)
	
	#If they were evenly spread out, each fire would rotate spread_direction by this many degrees before spawning
	var average_spread_direction_deviation_in_radians = (PI/2) / (num_new_fires+1)
	for i in num_new_fires:
		#But let's add some randomness to the number of degrees
		current_spread_direction = current_spread_direction.rotated(average_spread_direction_deviation_in_radians*randf_range(0.8,1.2))
		
		var new_fire_spread_distance = randf_range(min_spread_distance, max_spread_distance)
		var new_fire_position = global_position + (new_fire_spread_distance*current_spread_direction.normalized())
		spawn_fire(new_fire_position, current_spread_direction, 0)

func spawn_fire(spawn_position, new_fire_spread_direction, generation):
	var new_fire = child_fire_scene.instantiate()
	get_tree().current_scene.add_child(new_fire)
	new_fire.global_position = spawn_position
	new_fire.my_init(self, new_fire_spread_direction, generation+1)
