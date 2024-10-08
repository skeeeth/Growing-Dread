##Calls for interaction based on held item on tile infront of
## Player, as determined by movement raycast
extends Node
class_name GridInteraction

@export var movement:RayCast2D
var interaction:int
var crop:CropData
var _previous_target

## Called when the node enters the scene tree for the first time.
func _ready():
	crop = CORN;
	pass # Replace with function body.
const CORN = preload("res://Farming/FarmingTiles/Crops/Corn.tres")

func interact():
	if !movement.is_colliding(): return
	
	var target = movement.get_collider()
	if target is FarmTile:
		target.interact(interaction,crop)
	if target is Home:
		target.interact()
	pass
	
func _process(_delta):
	var interaction_text = $"../TextEdit"
	interaction_text.text = Farming.interactions.keys()[interaction]
	
	var target = movement.get_collider()
	if target is FarmTile:
		target.get_node("FarmableTile/Border").visible = true
	
	if _previous_target is FarmTile:
		if _previous_target != target:
			_previous_target.get_node("FarmableTile/Border").visible = false
	_previous_target = target


## temporary item selection, intent is to have a rearrangable
## inventory that assigns interaction type 
func _input(event):
	if event.is_action_pressed("1"):
		interaction = Farming.interactions.Till
	if event.is_action_pressed("2"):
		interaction = Farming.interactions.Plant
		crop = CORN
	if event.is_action_pressed("3"):
		interaction = Farming.interactions.Harvest

	if event.is_action_pressed("space"):
		interact()
