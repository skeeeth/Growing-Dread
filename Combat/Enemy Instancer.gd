extends Node
class_name EnemyInstancer

#var enemies:Array[Enemy]
var enemies = []
var night_active:bool = false
var num_queued_enemies:int = 1;
@onready var test_enemy_scene = preload("res://Combat/Enemies/wolf.tscn")
@onready var infested_wolf_scene = preload("res://Combat/Enemies/infested_wolf.tscn")

var regular_wolf_spawn_location_center = Vector2(-800, 200)

func _ready():
	Farming.night_fallen.connect(begin_night)

func begin_night():
	night_active = true

func spawn_regular_wolves(num_wolves_to_spawn:int):
	var sheep = get_tree().get_nodes_in_group("sheep")
	sheep.shuffle()
	print("Found " + str(len(sheep)) + " sheep")
	num_queued_enemies = num_wolves_to_spawn
	while num_queued_enemies > 0:
		if (num_queued_enemies <= len(sheep)): #Only spawn a wolf if we have a sheep we can assign as its target
			var new_enemy = test_enemy_scene.instantiate()
			new_enemy.assign_target_sheep(sheep[num_queued_enemies-1])
			enemies.append(new_enemy)
			new_enemy.died.connect(_on_enemy_death)
			new_enemy.global_position = regular_wolf_spawn_location_center + Vector2.from_angle(randf() * TAU) * randf() * 200
			add_child(new_enemy)
		
		num_queued_enemies -= 1

func spawn_infested_wolf():
	var infested_wolf = infested_wolf_scene.instantiate()
	infested_wolf.global_position = Vector2(0, 500)
	add_child(infested_wolf)

func end_night():
	night_active = false
	Farming.next_day()

func _on_enemy_death(id):
	enemies.erase(id)
	if enemies.size() == 0:
		Farming.event_active = false
	pass
