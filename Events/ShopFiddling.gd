extends Node

@export var inv:Inventory
@export var requirement:int
@export var texts:Array[String]
@export var next:Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	inv.inventory_toggled.connect(toggled)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func toggled(opened):
	if opened:
		requirement -= 1
		if requirement == 0:
			replace_text()
			requirement += randi_range(next.x,next.y)

func replace_text():
	var shop_slots:Array[InventorySlot]
	for node in inv.shop.get_node("ShopBack/Grid").get_children():
		if node is InventorySlot:
			shop_slots.append(node)
	
	var slot:InventorySlot = shop_slots.pick_random()
	var previous = slot.name_label.text
	slot.name_label.text = texts.pick_random()
	var flicker = create_tween()
	flicker.tween_property(slot.name_label,"text",previous,0.1).set_delay(0.2)
