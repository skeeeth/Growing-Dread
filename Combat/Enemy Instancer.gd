extends Node

#var enemies:Array[Enemy]
var enemies = []
var night_active:bool = false
var num_queued_enemies:int = 1;
@onready var test_enemy_scene = preload("res://Combat/Enemies/wolf.tscn") #preload("res://Combat/Enemies/test_enemy.tscn")


func _ready():
	Farming.night_fallen.connect(begin_night)


func _process(delta):
	if !night_active:
		return
	
	if num_queued_enemies > 0:
		return
		
	if enemies.size() > 0:
		return
	
	end_night()


func begin_night():
	night_active = true
	num_queued_enemies = Farming.day
	
	var sheep = get_tree().get_nodes_in_group("sheep")
	sheep.shuffle()
	print("Found " + str(len(sheep)) + " sheep")

	while num_queued_enemies > 0:
		
		if (num_queued_enemies <= len(sheep)): #Only spawn a wolf if we have a sheep we can assign as its target
			var new_enemy = test_enemy_scene.instantiate()
			new_enemy.assign_target_sheep(sheep[num_queued_enemies-1])
			enemies.append(new_enemy)
			new_enemy.died.connect(_on_enemy_death)
			new_enemy.position = Vector2.from_angle(randf() * TAU) * randf() * 200
			add_child(new_enemy)
		
		num_queued_enemies -= 1
	pass

func end_night():
	night_active = false
	Farming.next_day()

func _on_enemy_death(id):
	enemies.erase(id)
	pass
