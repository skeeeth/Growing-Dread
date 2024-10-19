extends HBoxContainer
class_name Stamina

@export var max_stam:int = 10
@export var inventory:Inventory
var costs:Dictionary = {
	Farming.interactions.Till: 1,
	Farming.interactions.Water: 1,
	Farming.interactions.Harvest: 3,
	Farming.interactions.Plant: 2,
	Farming.interactions.Burn: 0,
	Farming.interactions.Eat: 0,
	6: 0
}
var current:int = 10
var bars:Array[ColorRect]
@export var bar_color:Color
var cost:int
var hover_progress:float = 0


func _ready():
	for i in range(0,max_stam):
		var bar = ColorRect.new()
		bar.color = bar_color
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bars.append(bar)
		add_child(bar)
	inventory.slot_selected.connect(on_slot_selected)
	Farming.day_progressed.connect(on_day_start)
	
	await get_tree().process_frame #hack - wait a frame because the inventory slots might not be ready yet
	on_slot_selected(0)


func _process(delta):
	if bars.size() <= 0: return
	hover_progress += delta
	hover_progress =  wrap(hover_progress,0,PI)
	var hover_color = Color(Color.WHITE,sin(hover_progress))
	var b = current
	var a = max(current-cost,0)
	for i in range(0,current,1):
		bars[i].modulate = Color.WHITE
	
	for i in range(a,max_stam,1):
		bars[i].modulate = Color(Color.WHITE,0)

	for i in range(min(b,a),max(b,a),1):
		bars[i].modulate = hover_color
		

	pass

func on_slot_selected(i):
	var type = inventory.slots[i].interation_type
	cost = costs[type]

func on_day_start():
	current = max_stam
	pass

func try_use():
	if current-cost >= 0:
		#current -= cost #called in interaction only if interaction works
		return true
	else:
		#error
		var redflash = create_tween()
		redflash.tween_property(get_parent(),"modulate",Color.RED,0.2)
		redflash.tween_property(get_parent(),"modulate", Color.WHITE,0.2)
		return false
