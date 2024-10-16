extends Node

var farm_tiles:Array[FarmTile]
@export_group("BloodWater","blood_")
@export var blood_req:int
@export var blood_repeat:Vector2
@export var modulate_color:Color
@export_group("HarvestSquelch","squelch_")
@export var squelch_req:int
@export var squelch_repeat:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	var level = $"../../Level"
	for node in level.get_children():
		if node is FarmTile:
			farm_tiles.append(node)
			node.harvested.connect(on_harvest)
			node.planted.connect(on_plant)
			node.tilled.connect(on_till)
			node.watered.connect(on_water)
	pass # Replace with function body.

func on_harvest(source):
	var tile:FarmTile = source
	squelch_req -= 1
	if squelch_req == 0:
		squelch_req = randi_range(squelch_repeat.x,squelch_repeat.y)
		#do the thing
	pass
	
	
func on_water(source):
	var tile:FarmTile = source
	blood_req -= 1
	if blood_req == 0:
		blood_req = randi_range(blood_repeat.x,blood_repeat.y)
		var water_particle:CPUParticles2D = tile.get_node("FarmableTile/ParticleHolder/Watering")
		water_particle.modulate = modulate_color
		await water_particle.finished
		water_particle.modulate = Color.WHITE
		

func on_plant(source,crop):
	pass

func on_till(source):
	pass
