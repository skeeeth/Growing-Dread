extends Node2D

'''
I want to spawn monsters rapidly at first, then have the monster spawn rate quickly fall and level off
The kind of shape I'm going for is the function f(x) = 1 / (4x+1) from x=0 to x=1
So if spawn_duration=5 (for example), then I want the monster spawn rate at time t to be: num_monsters_per_second_initial / (4(t/5)+1)
'''

var num_monsters_initial_wave:int
@export var num_monsters_per_second_initial:int
@export var spawn_duration:float
@export var spawn_radius:float


@onready var monster_scene = preload("res://Combat/Enemies/monster.tscn")

var spawning = false

var current_monsters_per_second:float = 0
var num_monsters_due_to_spawn:float = 0
var time_elapsed = 0


func _process(delta):
	if (not spawning):
		return
		
	num_monsters_due_to_spawn += delta * current_monsters_per_second
	
	while (num_monsters_due_to_spawn >= 1):
		spawn_monster()
		num_monsters_due_to_spawn -= 1
	
	time_elapsed += delta
	if (time_elapsed > spawn_duration):
		queue_free()
	else:
		current_monsters_per_second = num_monsters_per_second_initial / ((4*(time_elapsed/spawn_duration)) + 1)


func init(new_num_monsters_initial_wave, new_num_monsters_per_second_initial, new_spawn_duration, new_spawn_radius):
	num_monsters_initial_wave = new_num_monsters_initial_wave
	num_monsters_per_second_initial = new_num_monsters_per_second_initial
	spawn_duration = new_spawn_duration
	spawn_radius = new_spawn_radius

	spawning = true
	num_monsters_due_to_spawn = num_monsters_initial_wave


func spawn_monster():
	var monster = monster_scene.instantiate()
	var spawn_location = global_position + Vector2.from_angle(randf() * TAU) * randf() * spawn_radius
	monster.global_position = spawn_location
	get_tree().current_scene.add_child(monster)
