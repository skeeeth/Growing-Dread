extends StaticBody2D
class_name Home

signal entered
signal exited
@export var interior_start_position:Vector2
@export var exterior_start_position:Vector2

@export var player_z_index_inside_adjustment:int

var is_inside = true

#@onready var player
@onready var door_sound = $Door

func _ready():
	_set_is_inside(true)
	#Farming.night_fallen.connect(retrigger_clear)



func interact(player):
	door_sound.play()
	if (is_inside):
		move_player_outside(player)
	else:
		move_player_inside(player)


func _set_is_inside(val:bool):
	is_inside = val
	
	$ExteriorCollisionShape.disabled = is_inside
	
	for node in $Interior/WallsStaticBody.get_children():
		if (node is CollisionShape2D):
			node.disabled = !is_inside
	
	$Interior.visible = is_inside



func move_player_inside(player):
	entered.emit()
	_set_is_inside(true)
	player.global_position = self.to_global(interior_start_position)
	player.z_index += player_z_index_inside_adjustment

func move_player_outside(player):
	exited.emit()
	_set_is_inside(false)
	player.global_position = self.to_global(exterior_start_position)
	player.z_index -= player_z_index_inside_adjustment


#func _on_area_2d_body_entered(body):
	#if body is FarmTile:
		#body.queue_free()
	#pass # Replace with function body.
#
#func retrigger_clear():
	#$Interior/Door/Area2D.monitoring = false
	#$Interior/Door/Area2D.monitoring = true
