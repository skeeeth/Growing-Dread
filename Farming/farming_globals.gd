extends Node

signal day_progressed
signal inventory_updated
signal night_fallen
signal woke_up
signal fell_asleep
signal started_burning(burn_position)

var day:int = 0
var is_nighttime = false

enum interactions{ Till, Plant, Water, Harvest, Burn, Eat }
enum states{ Untilled, Tilled, Planted, Growing, Ripe, Dead, }
var money = 10
var selected_interaction:int

var event_active = false
var fires:int = 0
	#set(v):

func _process(delta):
	if fires > 200:
		for fire in get_tree().get_nodes_in_group("Fire"):
			fire.queue_free()
		get_tree().change_scene_to_file.call_deferred("res://title_scene.tscn")

#var crop_prices: Dictionary = {
	#"Corn": 10, 
	#"Wheat": 8, 
#}
#
#var crop_images: Dictionary = {
	#"Wheat": "res://textures/icons/wheat.jpg",
	#"Corn": "res://textures/icons/corn.png",
#}
var crop_resources:Dictionary = { #getting these in this way seems wrong but idk
	"Corn": "res://Farming/FarmingTiles/Crops/Corn.tres",
	"Tomato": "res://Farming/FarmingTiles/Crops/Tomato.tres",
}
const EMPTY_ITEM = preload("res://Farming/FarmingTiles/Crops/Empty.tres")

var inventory:Inventory #probably bad practice to have your autoload reference a specific node
						#that sets itself in its ready script but it works


func go_to_sleep():
	fell_asleep.emit()

func wake_up():
	woke_up.emit()
	
func go_to_night():
	is_nighttime = true
	night_fallen.emit()

func next_day():
	is_nighttime = false
	day += 1;
	day_progressed.emit()
	
func burn_down_farm(burn_pos):
	started_burning.emit(burn_pos)

#func _input(event):
	#if event.is_action_pressed("0"):
		#next_day()

func add_item(item_data):
	for slot in inventory.slots:
		if slot.data == item_data:
			slot.count += 1
			return
	
	#var index = 0
	for slot in inventory.slots:
		if slot.data == EMPTY_ITEM:
			slot.data = item_data
			slot.count = 1
			return
		

#func sell_crop(crop_name):
	#var count = inventory[crop_name]
	#if count != null && count > 0:
		#money += crop_prices[crop_name]
		#inventory[crop_name] -= 1
		#if inventory[crop_name] == 0:
			#inventory.erase(crop_name)
			#
		#inventory_updated.emit()
	
