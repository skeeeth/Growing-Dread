extends Node

signal day_progressed
signal inventory_updated
var day:int = 0
enum interactions{Till,Plant,Water,Harvest,}
enum states{Untilled,Tilled,Growing,Ripe,Dead}
var money = 0

var crop_prices: Dictionary = {
	"Corn": 10, 
	"Wheat": 8, 
}

var crop_images: Dictionary = {
	"Wheat": "res://textures/icons/wheat.jpg",
	"Corn": "res://textures/icons/corn.png"
}

var inventory: Dictionary = {
	
}


func next_day():
	day += 1;
	day_progressed.emit()

func _input(event):
	if event.is_action_pressed("0"):
		next_day()

func add_item(item_name):
	print('new item: ', item_name)
	if item_name in inventory:
		inventory[item_name] += 1
	else:
		inventory[item_name] = 1
	inventory_updated.emit()

func sell_crop(crop_name):
	var count = inventory[crop_name]
	if count != null && count > 0:
		money += crop_prices[crop_name]
		inventory[crop_name] -= 1
		if inventory[crop_name] == 0:
			inventory.erase(crop_name)
			
		inventory_updated.emit()
	
