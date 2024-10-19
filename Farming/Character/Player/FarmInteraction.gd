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
var stamina:Stamina

@onready var thoughts = $Thoughts

var can_burn:bool = false
var torch_equipped:bool = false
var did_burn_interaction = false

func _ready():	
	stamina = get_tree().get_first_node_in_group("Stamina")


const BLANK = preload("res://Farming/FarmingTiles/Crops/Blank.tres")


func allow_player_to_burn_one_time():
	if (!did_burn_interaction): #already happened. Don't let them do it again
		can_burn = true


func interact():
	inventory = Farming.inventory
	
	if !interaction_raycast.is_colliding(): return
	var slot = inventory.slots[inventory.selected_slot_index]
	var type = slot.data.interation_type
	if type == Farming.interactions.Eat:
		slot.consume()
		stamina.current += stamina.costs[type]
	
	var target = interaction_raycast.get_collider()
	if target is FarmTile:
		#if (torch_equipped):
			#if (can_burn and (not target.burning)):
				#target.burn()
				#can_burn = false
				#target.border.visible = false
				#Farming.burn_down_farm()
				#await get_tree().create_timer(10).timeout
				#create_tween().tween_property($"../SceneChangeCover","modulate:a",1,15)
				#await get_tree().create_timer(15).timeout
				#get_tree().change_scene_to_file("res://title_scene.tscn") #replace with credits scene
		#elif (not target.is_dummy_burnable_tile):
		if (Farming.is_nighttime):
			if type != Farming.interactions.Burn: return
			
		if !stamina.try_use():
			error_sound.play()
			return
		var crop
		if slot.data.crop_name != "":
			crop = load(Farming.crop_resources[slot.data.crop_name])
		else:
			crop = BLANK
			assert(type != Farming.interactions.Plant) #seeds should have a crop reference in Farming
		if target.interact(type,crop): #interact is called here regardless
			slot.consume() #will put non-consumables "count" to lower negatives
			stamina.current -= stamina.cost
		else:
			#if interacting with wrong type
			error_sound.play()
	if target is Home:
		target.interact(get_parent())
	if target is Door:
		target.interact($"..")
	if target is Bed:
		var failed = false
		if stamina.current > 3:
			thoughts.text = "Not tired!"
			failed= true
		if Farming.event_active:
			thoughts.text = "Somethings going on..."
			failed = true
		if !failed:
			target.interact($"..")
			$"../farmer_image".play("Idle")
		create_tween().tween_property(thoughts,"text", "",0.0).set_delay(2.0)
	
	
func _process(_delta):
	#var interaction_text = $"../TextEdit"
	#interaction_text.text = Farming.interactions.keys()[interaction]
	var target = interaction_raycast.get_collider()
	if target is FarmTile:
		target.border.visible = true
	
	if _previous_target is FarmTile:
		if _previous_target != target:
			_previous_target.border.visible = false
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
