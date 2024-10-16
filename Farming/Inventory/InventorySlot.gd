extends VBoxContainer
class_name InventorySlot

signal transaction_completed

@export var is_shop:bool
@export var count:int:
	set(v):
		count = v
		count_label.text = str(v)

@export var count_label:Label
@export var img:TextureRect
@export var hotkey_label:Label
var interation_type:int
@export var button:Button
@onready var panel = $PanelContainer
@export var data:ItemData:
	set(v):
		data = v
		update()

@onready var buy_sound = $Buy
@onready var sell_sound = $Sell
@export var name_label:Label

# Called when the node enters the scene tree for the first time.
func _ready():
	update() 	#we're using @export in a a ton of spots where @onready
				#would normally go because @onready doesnt resolve in time
	name_label.text = data.crop_name
	if data.interation_type == Farming.interactions.Plant:
		name_label.text += " Seed"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func button_down():
	if is_shop:
		if Farming.money >= data.buy_cost:
			buy_sound.play()
			Farming.money -= data.buy_cost
			Farming.add_item(data)
	else:
		sell_sound.play()
		Farming.money += data.money_value
		consume()
	transaction_completed.emit()

func consume():
	count -= 1
	if count == 0:
		data = Farming.EMPTY_ITEM

func update():
	img.texture = data.inventory_image
	interation_type = data.interation_type
	
	count_label.visible = !count == -1

	if is_shop:
		button.text = "Buy\n$" + str(data.buy_cost)
		hotkey_label.visible = false
		name_label.visible = true
	else:
		button.text = "Sell"
		button.visible = data.sellable
		name_label.visible = false

const _DRAG_ITEM = preload("res://Farming/Inventory/drag_item.tscn")

func _get_drag_data(_at_position:Vector2):
	var drop_data = {}
	drop_data["origin_slot"] = self
	drop_data["item_data"] = data
	drop_data["count"] = count
	
	var dragPreview =  _DRAG_ITEM.instantiate()
	dragPreview.texture = data.inventory_image
	dragPreview.scale = panel.size/data.inventory_image.get_size()
	add_child(dragPreview)
	return drop_data
	
func _can_drop_data(_at_position, _d_data):
	return !is_shop
	
func _drop_data(at_position, drop_data):
	drop_data["origin_slot"].count = count
	count = drop_data["count"]
	
	drop_data["origin_slot"].data = data
	data = drop_data["item_data"]
