extends Node2D
class_name ChildFire

var min_growth_time = 4
var max_growth_time = 8
var growth_time = 8

var min_num_spreads = 2
var max_num_spreads = 4

var min_spread_distance = 30
var max_spread_distance = 40

var extra_spread_distance_per_generation = 5

var parent_fire

func _ready():
	print("I am a child fire with position: " + str(global_position))

func my_init(new_parent_fire, new_spread_direction, generation=1):
	parent_fire = new_parent_fire
	$MySprite/AnimationPlayer.play("fire_flicker")
	
	growth_time = randf_range(min_growth_time, max_growth_time)
	
	create_tween().tween_property($MySprite,"scale",Vector2(4,4),growth_time) 
	await get_tree().create_timer(growth_time).timeout
	spread(new_spread_direction, generation)

func spread(_spread_direction, generation):
	print("I am a child with global_position: " + str(global_position))
	var num_new_fires = randi_range(min_num_spreads, max_num_spreads)
	num_new_fires = max(1, num_new_fires - int(generation/3))
	#Each new fire should spread in spread_direction, plus or minus up to 45 degrees
	#So let's start at -45 degrees...
	var current_spread_direction = _spread_direction.rotated(-PI/4)
	
	#If they were evenly spread out, each fire would rotate spread_direction by this many degrees before spawning
	var average_spread_direction_deviation_in_radians = (PI/2) / (num_new_fires+1)
	for i in num_new_fires:
		#But let's add some randomness to the number of degrees
		
		current_spread_direction = current_spread_direction.rotated(average_spread_direction_deviation_in_radians*randf_range(0.8,1.2))
		print("Starting spread dir: " + str(_spread_direction) + " vs ending spread dir: " + str(current_spread_direction))
		var new_fire_spread_distance = randf_range(min_spread_distance, max_spread_distance) + generation*extra_spread_distance_per_generation
		var new_fire_position = global_position + (new_fire_spread_distance*current_spread_direction.normalized())
		
		parent_fire.spawn_fire(new_fire_position, current_spread_direction, generation)
