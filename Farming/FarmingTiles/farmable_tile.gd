extends Node2D
class_name FarmTile

var state:int = Farming.states.Untilled:
	set(a_state):
		match a_state:
			Farming.states.Untilled:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Untilled"
			Farming.states.Tilled:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Tilled"
			Farming.states.Planted:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Planted"
			Farming.states.Growing:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Growing"
			Farming.states.Ripe:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Ripe"
			Farming.states.Dead:
				state = a_state
				$FarmableTile/CropDisplay.animation = "Dead"
			_:
				print("Warning : farmable_tile.gd::_set_state(...)! Undefined farmable_tile state!")
	get:
		return state

@export var crop_data:CropData
var plant_day:int         = -1
var last_water_day:int    = -1
@onready var crop_display = $FarmableTile/CropDisplay
@onready var dirt         = $FarmableTile/Dirt
@onready var occluder     = $FarmableTile/Occluder




const BLANK = preload("res://Farming/FarmingTiles/Crops/Blank.tres")




func _ready():
	Farming.day_progressed.connect(day_progression)
	_set_state(Farming.states.Untilled)
	$FarmableTile/CropDisplay.play()




func interact(type,data):
	match type:
		Farming.interactions.Plant: plant(data)
		Farming.interactions.Till: till()
		Farming.interactions.Water: water()
		Farming.interactions.Harvest: harvest()




func harvest():
	if state == Farming.states.Ripe:
		_set_state(Farming.states.Untilled)
		#collect the item into the player's inventory
		#Farming.add_item(crop_data.name)
		#crop_data = BLANK;
		
		#state = Farming.states.Untilled
		#crop_display.visible = false
		#occluder.occluder_light_mask = 0




func till():
	if state == Farming.states.Untilled:
		_set_state(Farming.states.Tilled)




func water():
	if state == Farming.states.Growing:
		last_water_day = Farming.day
	pass




func plant(data):
	if state == Farming.states.Tilled:
		
		plant_day = Farming.day
		_set_state(Farming.states.Growing)
		#crop_data = data
		#crop_display.sprite_frames = crop_data.images
		#crop_display.visible = true




# Set the farmable_tile's state and animation.
# 	param a_state (enum) - the "Farming.states" found in farming_globals.gd.
#
# 	                                                                            Maria-Antoinette
func _set_state(a_state):
	print("Deprecated _set_state(...) function. Image is set when the state.set function is called")
#	match a_state:
#		Farming.states.Untilled:
#			state = Farming.states.Untilled
#			$FarmableTile/CropDisplay.animation = "Untilled"
#		Farming.states.Tilled:
#			state = Farming.states.Tilled
#			$FarmableTile/CropDisplay.animation = "Tilled"
#		Farming.states.Planted:
#			state = Farming.states.Planted
#			$FarmableTile/CropDisplay.animation = "Planted"
#		Farming.states.Growing:
#			state = Farming.states.Growing
#			$FarmableTile/CropDisplay.animation = "Growing"
#		Farming.states.Ripe:
#			state = Farming.states.Ripe
#			$FarmableTile/CropDisplay.animation = "Ripe"
#		Farming.states.Dead:
#			state = Farming.states.Dead
#			$FarmableTile/CropDisplay.animation = "Dead"
#		_:
#			print("Warning : farmable_tile.gd::_set_state(...)! Undefined farmable_tile state!")




func _set_image(value):
	print("Deprecated _set_image(...) function. Image is set when the _set_state function is called")
	#if value == Farming.states.Growing:
	#	var age = Farming.day - plant_day
		#Play Appropriate "Growing-X" animation
		
		#Determine how many growing animations this plant has
	#	var growing_count:int = 0
	#	for s in crop_data.images.get_animation_names():
	#		if s.contains("Growing"):
	#			growing_count += 1
		
	#	var progress = float(age) / float(crop_data.days_to_ripen)
	#	var animation_number = str(round(progress * growing_count))
	#	if animation_number == "0":
	#		crop_display.play("Planted")
	#	else:
	#		crop_display.play("Growing-" + animation_number)
	#	print("playing growing-" + animation_number + "for " + str(progress) + " progress")
		
	#if value == Farming.states.Ripe:
	#	crop_display.play("Ripe")
	
	#if value == Farming.states.Tilled:
	#	dirt.frame = 1
	#if value == Farming.states.Untilled:
	#	dirt.frame = 2
	#could maybe have multiple frames for the growing phase
	# which would require more logic involving age




func day_progression(day_overide:int = -1):
	
	var new_day = Farming.day
	if day_overide >= 0:
		new_day = day_overide
		
	var age:int = new_day - plant_day
	
	if age == crop_data.days_to_ripen:
		_set_state(Farming.states.Ripe)
		#state = Farming.states.Ripe
		#occluder.occluder_light_mask = 1

	if age == crop_data.days_to_death:
		_set_state(Farming.states.Dead)
		
	#_set_image(state)
