extends Control
class_name Inventory

signal slot_selected(slot)
signal inventory_toggled(offon)

@export var shop_contents:Control

var slots:Array[InventorySlot]
@onready var hotbar = $VBoxContainer/Hotbar
var selected_slot_index:int = 0

@onready var selection_indicator = $VBoxContainer/Hotbar/HotbarSelection
@onready var selected_sound = $Selected
@onready var inventory_sound = $OpenClose

func _ready():
	Farming.inventory = self
	#Farming.inventory_updated.connect(on_inventory_update)
	var slot_scene:PackedScene = load("res://Farming/Inventory/InventorySlot.tscn")
	
	for s in hotbar.get_children():
		if s is InventorySlot:
			slots.append(s)
	
	for i in range(0,5):
		var new_slot:InventorySlot = slot_scene.instantiate()

		new_slot.data = Farming.EMPTY_ITEM
		hotbar.add_child(new_slot)
		slots.append(new_slot)
	for i in range(0,slots.size()):
		slots[i].hotkey_label.text = str(i+1)
	
	var si_scale =slots[0].panel.size.x/26.0
	selection_indicator.scale = Vector2(si_scale,si_scale)

func _input(event):
	if Farming.is_nighttime: return
	if event.is_action_pressed("inventory"):
		toggle_expand()
	
	var i = int(event.as_text())
	#print(i)
	if i > 0 and  i <= 9:
		if i-1 != selected_slot_index:
			selected_sound.play()
			slot_selected.emit(i-1)
		selected_slot_index = i-1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var slot_w = slots[0].panel.size.x + 1.0
	var slot0_position = slots[0].position
	selection_indicator.position.x = slot0_position.x + slot_w * (selected_slot_index + 0.5)
	selection_indicator.position.y = slots[0].panel.size.y/2.0



func _on_texture_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			toggle_expand()
	pass # Replace with function body.

func toggle_expand():
	shop_contents.visible = !shop_contents.visible
	inventory_toggled.emit(shop_contents.visible)
	inventory_sound.play()
