extends Node

@onready var inventory_base = $ColorRect/GridContainer
@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.inventory_updated.connect(on_inventory_update)


func _input(event):
	if event.is_action_pressed("inventory"):
		color_rect.visible = !color_rect.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func instantiate_image(item_name):
	var img = load("res://Farming/inventory_item.tscn")
	var inst = img.instantiate()
	
	inventory_base.add_child(inst)
	inst.set_item(item_name)

	
func on_inventory_update():
	# Iterate over each item in the inventory dictionary
	for item_name in Farming.inventory.keys():
		var has_existing = false
		for existing in inventory_base.get_children():
			if(existing.item_type == item_name):
				has_existing = true
				
		if not has_existing:
			# The item doesn't exist as a child, so let's create it
			instantiate_image(item_name)

	# Now, let's check for any orphaned children (items not in the inventory)
	for child in inventory_base.get_children():
		if child.item_type not in Farming.inventory:
			# This child's item_type is not in the inventory—remove it
			child.queue_free()
