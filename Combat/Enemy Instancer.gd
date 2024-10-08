extends Node

var enemies:Array[Enemy]
var night_active:bool = false
var queued_enemies:int = 1;
@onready var test_enemy_scene = preload("res://Combat/Enemies/test_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.night_fallen.connect(begin_night)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !night_active:
		return
	
	if queued_enemies > 0:
		return
		
	if enemies.size() > 0:
		return
	
	end_night()
	pass

func begin_night():
	night_active = true
	queued_enemies = Farming.day
	while queued_enemies > 0:
		queued_enemies -= 1
		var new_enemy = test_enemy_scene.instantiate()
		enemies.append(new_enemy)
		new_enemy.died.connect(_on_enemy_death)
		new_enemy.position = Vector2.from_angle(randf() * TAU) * randf() * 200
		add_child(new_enemy)
	pass

func end_night():
	night_active = false
	Farming.next_day()

func _on_enemy_death(id):
	enemies.erase(id)
	pass
