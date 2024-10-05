extends TextureRect

var item_type = ''
@onready var img = $"."
@onready var label = $Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item_type in Farming.inventory:  
		label.text = str(Farming.inventory[item_type])



func _on_button_pressed():
	Farming.sell_crop(item_type)
	
func set_item(item_name):
	item_type = item_name
	var item_img_path = Farming.crop_images[item_name]
	print(item_img_path)
	var item_tex = load(item_img_path)
	img.texture = item_tex
	
