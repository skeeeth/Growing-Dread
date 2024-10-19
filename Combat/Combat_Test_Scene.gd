extends Node2D

const CORN = preload("res://Farming/FarmingTiles/Crops/Corn.tres")
##@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
	#for n in get_children(true):
		#if n is FarmTile:	
			#n.till()
			#n.plant(CORN)
			#Farming.next_day() #note this is the global call, will affect all planted crops


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#func _input(event):
	#if event.is_action_pressed("8"):
		#for n in tile_map.get_children(true):
			#if n is FarmTile:
				#n.crop_data = CORN
				#n.state = Farming.states.Ripe
