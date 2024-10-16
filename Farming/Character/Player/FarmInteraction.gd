##Calls for interaction based on held item on tile infront of
## Player, as determined by interaction_raycast raycast
extends Node
class_name GridInteraction

@export var interaction_raycast:RayCast2D
#var interaction:int = 2
#var crop:CropData
var _previous_target
var inventory:Inventory
@onready var error_sound = $"../Error"

## Called when the node enters the scene tree for the first time.
func _ready():
	inventory = Farming.inventory
	pass # Replace with function body.
#const CORN = preload("res://Farming/FarmingTiles/Crops/Corn.tres")
const BLANK = preload("res://Farming/FarmingTiles/Crops/Blank.tres")
func interact():
	if !interaction_raycast.is_colliding(): return
	
	var target = interaction_raycast.get_collider()
	if target is FarmTile:
		var slot = inventory.slots[inventory.selected_slot_index]
		var type = slot.data.interation_type
		var crop
		if slot.data.crop_name != "":
			crop = load(Farming.crop_resources[slot.data.crop_name])
		else:
			crop = BLANK
			assert(type != Farming.interactions.Plant) #seeds should have a crop reference in Farming
		if target.interact(type,crop): #interact is called here regardless
			slot.consume() #will put non-consumables "count" to lower negatives
		else:
			#if interacting with wrong type
			error_sound.play()
		
	if target is Home:
		target.interact(get_parent())
	if target is Door:
		target.interact($"..")
	if target is Bed:
		target.interact($"..")
	
	
func _process(_delta):
	#var interaction_text = $"../TextEdit"
	#interaction_text.text = Farming.interactions.keys()[interaction]
	
	var target = interaction_raycast.get_collider()
	if target is FarmTile:
		target.get_node("FarmableTile/Border").visible = true
	
	if _previous_target is FarmTile:
		if _previous_target != target:
			_previous_target.get_node("FarmableTile/Border").visible = false
	_previous_target = target


## temporary item selection, intent is to have a rearrangable
## inventory that assigns interaction type 
func _input(event):
	#if event.is_action_pressed("1"):
		#interaction = Farming.interactions.Till
	#if event.is_action_pressed("2"):
		#interaction = Farming.interactions.Plant
		#crop = CORN
	#if event.is_action_pressed("3"):
		#interaction = Farming.interactions.Harvest

	if event.is_action_pressed("space"):
		interact()
