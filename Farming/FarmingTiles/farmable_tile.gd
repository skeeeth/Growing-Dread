extends Node2D
class_name FarmTile

@export var state:int = Farming.states.Untilled:
	set(v):
		state = v
		_set_image(state)
	get:
		return state
@export var crop_data:CropData
var plant_day:int = -1
var last_water_day:int = -1
@onready var crop_display = $FarmableTile/CropDisplay
@onready var dirt = $FarmableTile/Dirt
@onready var occluder = $FarmableTile/Occluder

const BLANK = preload("res://Farming/FarmingTiles/Crops/Blank.tres")
@onready var animation_player = $AnimationPlayer

func _ready():
	Farming.day_progressed.connect(day_progression)


	

func interact(type,data):
	match type:
		Farming.interactions.Plant: plant(data)
		Farming.interactions.Till: till()
		Farming.interactions.Water: water()
		Farming.interactions.Harvest: harvest()
	pass

func harvest():
	if state == Farming.states.Ripe:
		animation_player.play("Harvest")
		#collect the item into the player's inventory
		Farming.add_item(crop_data.name)
		await animation_player.animation_finished
		crop_data = BLANK;
		state = Farming.states.Untilled
		crop_display.visible = false
		occluder.occluder_light_mask = 0
	pass

func till():
	if state == Farming.states.Untilled:
		animation_player.play("Till")
		

func water():
	if state == Farming.states.Growing:
		last_water_day = Farming.day
	pass

func plant(data):
	if state == Farming.states.Tilled:
		animation_player.play("Plant")
		await animation_player.animation_finished
		crop_data = data
		crop_display.sprite_frames = crop_data.images
		crop_display.visible = true
		plant_day = Farming.day
		state = Farming.states.Growing

func _set_image(value):
	if value == Farming.states.Growing:
		var age = Farming.day - plant_day
		#Play Appropriate "Growing-X" animation
		
		#Determine how many growing animations this plant has
		var growing_count:int = 0
		for s in crop_data.images.get_animation_names():
			if s.contains("Growing"):
				growing_count += 1
		
		var progress = float(age) / float(crop_data.days_to_ripen)
		var animation_number = str(round(progress * growing_count))
		if animation_number == "0":
			crop_display.play("Planted")
		else:
			crop_display.play("Growing-" + animation_number)
		print("playing growing-" + animation_number + "for " + str(progress) + " progress")
		
	if value == Farming.states.Ripe:
		crop_display.play("Ripe")
	
	if value == Farming.states.Tilled:
		dirt.frame = 1
	if value == Farming.states.Untilled:
		dirt.frame = 0
	pass
	
func day_progression(day_overide:int = -1):
	
	var new_day = Farming.day
	if day_overide >= 0:
		new_day = day_overide
		
	var age:int = new_day - plant_day
	
	if age == crop_data.days_to_ripen:
		state = Farming.states.Ripe
		occluder.occluder_light_mask = 1

	if age == crop_data.days_to_death:
		state = Farming.states.Dead
		
	_set_image(state)
