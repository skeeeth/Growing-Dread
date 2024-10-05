extends Node2D
class_name FarmTile

var state:int = Farming.states.Untilled:
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
		crop_data = BLANK;
		state = Farming.states.Untilled
		crop_display.visible = false
		occluder.occluder_light_mask = 0
		##TODO:add to inventory based on crop_data
	pass

func till():
	if state == Farming.states.Untilled:
		state = Farming.states.Tilled
		

func water():
	if state == Farming.states.Growing:
		last_water_day = Farming.day
	pass

func plant(data):
	if state == Farming.states.Tilled:
		crop_data = data
		crop_display.sprite_frames = crop_data.images
		crop_display.visible = true
		plant_day = Farming.day
		state = Farming.states.Growing

func _set_image(value):
	if value > 1:
		crop_display.frame = value - 2;
	else:
		dirt.frame = value
	#could maybe have multiple frames for the growing phase
	# which would require more logic involving age
	pass
	
func day_progression(day_overide:int = -1):
	
	var new_day = Farming.day
	if day_overide >= 0:
		new_day = day_overide
		
	var age:int = new_day - plant_day
	#if state == Farming.states.Tilled:
		#crop_display.frame = 1
	#if state == Farming.states.Untilled:
		#crop_display.frame = 0
	if age == crop_data.days_to_ripen:
		state = Farming.states.Ripe
		occluder.occluder_light_mask = 1
	if age == crop_data.days_to_death:
		state = Farming.states.Dead
		
