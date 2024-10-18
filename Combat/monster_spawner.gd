extends Node2D
class_name MonsterSpawner

'''
I want to spawn monsters rapidly at first, then have the monster spawn rate quickly fall and level off
The kind of shape I'm going for is the function f(x) = 1 / (4x+1) from x=0 to x=1
So if spawn_duration=5 (for example), then I want the monster spawn rate at time t to be: num_monsters_per_second_initial / (4(t/5)+1)
'''

var num_monsters_initial_wave:int
@export var num_monsters_per_second_initial:int
@export var spawn_duration:float
@export var spawn_radius:float

@onready var monster_scene = preload("res://Combat/Enemies/lightweight_monster.tscn")

var spawning = false

var current_monsters_per_second:float = 0
var num_monsters_due_to_spawn:float = 0
var time_elapsed = 0

var monsters_spawned = []

var player_to_target = null
#@export var num_monsters_to_start_chasing_player_each_frame:int

@export var desired_num_monsters_chasing_player:int
var current_num_monsters_chasing_player = 0

var monsters_chasing_player = {}
var monsters_not_chasing_player = {}


func _process(delta):
	while (len(monsters_chasing_player) < desired_num_monsters_chasing_player and len(monsters_not_chasing_player) > 0):
		var new_chaser_inst_id = monsters_not_chasing_player.keys().pick_random()
		monsters_chasing_player[new_chaser_inst_id] = null
		monsters_not_chasing_player.erase(new_chaser_inst_id)
		
		var new_chaser = instance_from_id(new_chaser_inst_id)
		new_chaser.start_chasing_player()
		
	if (not spawning):
		return
		
	num_monsters_due_to_spawn += delta * current_monsters_per_second
	
	while (num_monsters_due_to_spawn >= 1):
		spawn_monster()
		num_monsters_due_to_spawn -= 1
	
	time_elapsed += delta
	if (time_elapsed > spawn_duration):
		spawning = false
	else:
		current_monsters_per_second = num_monsters_per_second_initial / ((4*(time_elapsed/spawn_duration)) + 1)


func on_monster_died(monster_id):
	return
	if (monsters_chasing_player.has(monster_id)):
		on_monster_stopped_chasing_player(monster_id)
	else:
		monsters_not_chasing_player.erase(monster_id)


func on_monster_stopped_chasing_player(monster_inst_id):
	monsters_not_chasing_player[monster_inst_id] = null
	monsters_chasing_player.erase(monster_inst_id)
	return
	if (len(monsters_not_chasing_player) > 0):
		#print("Found replacement monster")
		var new_chaser_inst_id = monsters_not_chasing_player.keys().pick_random()
		monsters_chasing_player[new_chaser_inst_id] = null
		monsters_not_chasing_player.erase(new_chaser_inst_id)
		
		var new_chaser = instance_from_id(new_chaser_inst_id)
		new_chaser.start_chasing_player()
	else:
		pass#print("Couldn't find a replacement monster")
	
	print("num monsters chasing player: " + str(len(monsters_chasing_player)))


func init(new_num_monsters_initial_wave, new_num_monsters_per_second_initial, new_spawn_duration, new_spawn_radius, new_player_to_target=null):
	num_monsters_initial_wave = new_num_monsters_initial_wave
	num_monsters_per_second_initial = new_num_monsters_per_second_initial
	spawn_duration = new_spawn_duration
	spawn_radius = new_spawn_radius

	spawning = true
	num_monsters_due_to_spawn = num_monsters_initial_wave
	if (new_player_to_target != null):
		player_to_target = new_player_to_target


func spawn_monster():
	var monster = monster_scene.instantiate()
	var spawn_location = global_position + Vector2.from_angle(randf() * TAU) * randf() * spawn_radius
	monster.global_position = spawn_location
	
	get_tree().current_scene.add_child(monster)
	
	if (player_to_target == null):
		print("Player was null, so go chase sheep")
		monster.start_chasing_sheep()
	else:
		print("Player was NOT null")
		monster.died.connect(on_monster_died)
		monster.stopped_chasing_player.connect(on_monster_stopped_chasing_player)
		monster.player = player_to_target
		if (len(monsters_chasing_player) < desired_num_monsters_chasing_player):
			monster.start_chasing_player()
			monsters_chasing_player[monster.get_instance_id()] = null
		else:
			monsters_not_chasing_player[monster.get_instance_id()] = null
	
