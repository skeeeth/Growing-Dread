extends Control
class_name Inventory

signal slot_selected(slot)
#@onready var inventory_base = $ColorRect/GridContainer
@onready var shop = $Shop
var slots:Array[InventorySlot]
@onready var hotbar =$Hotbar
var selected_slot_index:int = 0
@onready var selection_indicator = $Hotbar/HotbarSelection
@onready var selected_sound = $Selected
# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.inventory = self
	#Farming.inventory_updated.connect(on_inventory_update)
	var slot_scene:PackedScene = load("res://Farming/Inventory/InventorySlot.tscn")
	
	for s in hotbar.get_children():
		if s is InventorySlot:
			slots.append(s)
	
	for i in range(0,7):
		var new_slot:InventorySlot = slot_scene.instantiate()

		new_slot.data = Farming.EMPTY_ITEM
		hotbar.add_child(new_slot)
		slots.append(new_slot)
	for i in range(0,slots.size()):
		slots[i].hotkey_label.text = str(i+1)
	
	var si_scale =slots[0].panel.size.x/26.0
	selection_indicator.scale = Vector2(si_scale,si_scale)

func _input(event):
	if event.is_action_pressed("inventory"):
		toggle_expand()
	
	var i = int(event.as_text())
	#print(i)
	if i > 0 and  i <= 9:
		selected_slot_index = i-1
		if i-1 != selected_slot_index:
			selected_sound.play()
			slot_selected.emit(i)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var slot_w = slots[0].panel.size.x + 1.0
	selection_indicator.position.x = slot_w * (selected_slot_index + 0.5)
	selection_indicator.position.y = slots[0].panel.size.y/2.0
	pass
	
#func instantiate_image(item_name):
	#var img = load("res://Farming/inventory_item.tscn")
	#var inst = img.instantiate()
	#
	#inventory_base.add_child(inst)
	#inst.set_item(item_name)

	#
#func on_inventory_update():
	## Iterate over each item in the inventory dictionary
	#for item_name in Farming.inventory.keys():
		#var has_existing = false
		#for existing in inventory_base.get_children():
			#if(existing.item_type == item_name):
				#has_existing = true
				#
		#if not has_existing:
			## The item doesn't exist as a child, so let's create it
			#instantiate_image(item_name)
#
	## Now, let's check for any orphaned children (items not in the inventory)
	#for child in inventory_base.get_children():
		#if child.item_type not in Farming.inventory:
			## This child's item_type is not in the inventory—remove it
			#child.queue_free()


func _on_texture_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			toggle_expand()
	pass # Replace with function body.

func toggle_expand():
	shop.visible = !shop.visible
	pass
