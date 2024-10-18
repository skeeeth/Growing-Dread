extends Node

@export var tree_wakeup_day:int
@export var crop_death_day:int
@export var crop_swap_day:int
@export var extra_plant_day:int
@export var mite_day:int
@export var mite_sprite:Texture2D
var trees_awake:bool = false
var _trees:Array[EyeTree]
var _home:Home
# Called when the node enters the scene tree for the first time.
func _ready():
	Farming.woke_up.connect(on_wake_up)
	_home = get_tree().get_first_node_in_group("Home")
	_home.entered.connect(on_house_entered)
	
	for node in $"../../Level".get_children():
		if node is EyeTree:
			_trees.append(node)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if trees_awake:
		for tree in _trees:
			tree.look_at_position(tree.get_global_mouse_position())
	#on_house_entered()

func on_wake_up():
	if Farming.day == tree_wakeup_day:
		trees_awake = true
	if Farming.day == crop_death_day:
		var tiles:Array[FarmTile]
		for node in $"../../Level".get_children():
			if node is FarmTile:
				tiles.append(node)
				node.state = Farming.states.Tilled
				node.plant(load("res://Farming/FarmingTiles/Crops/Corn.tres"))
				await node.animation_player.animation_finished
		for tile in tiles:
			tile.state = Farming.states.Dead
			tile.harvest()
	
	if Farming.day == crop_swap_day:
		var planted_tiles:Array[FarmTile]
		var tiles:Array[FarmTile]
		for node in $"../../Level".get_children():
			if node is FarmTile:
				tiles.append(node)
				if node.state == Farming.states.Growing or\
							node.state == Farming.states.Ripe:
					planted_tiles.append(node)
					
		if planted_tiles.size() < 1: 
			crop_swap_day += 1
			return
		
		var selected_tile_one = planted_tiles.pick_random()
		var selected_tile_two = tiles.pick_random()
		while selected_tile_one == selected_tile_two:
			selected_tile_two = tiles.pick_random()
		var temp = selected_tile_one.global_position
		selected_tile_one.global_position = selected_tile_two.global_position
		selected_tile_two.position = temp
	
	if Farming.day == extra_plant_day:
		var unplanted_tilled_tiles:Array[FarmTile]
		for node in $"../../Level".get_children():
			if node is FarmTile:
				if node.state == Farming.states.Tilled:
					unplanted_tilled_tiles.append(node)
		if unplanted_tilled_tiles.size() < 1:
			extra_plant_day += 1;
			return
		unplanted_tilled_tiles.pick_random().plant(load("res://Farming/FarmingTiles/Crops/Tomato.tres"))
	pass

func on_house_entered():
	if trees_awake:
		var tree = _trees.pick_random()
		var dir = _home.global_position - tree.global_position
		
		if dir.length() < 300: return
		tree.global_position += dir.normalized() * 30
	
	if Farming.day >= mite_day:
		var tree = _trees.pick_random()
		var mite = Sprite2D.new()
		mite.texture = mite_sprite
		mite.scale = Vector2(0.1,0.1)
		tree.add_child(mite)
		mite.position = randf_range(100,300) * Vector2.from_angle(randf()*TAU)
		var move_die = create_tween()
		move_die.tween_property(mite,"position",Vector2(0,-10.0),1.0).set_delay(0.1)
		move_die.tween_callback(mite.queue_free)
