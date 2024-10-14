extends Node2D

@export var tree_texture:Texture2D
@export var tree_region_rect:Rect2

@export var tree_shadow_texture:Texture2D
@export var tree_trunk_texture:Texture2D
@export var tree_foliage_texture:Texture2D

#@onready var tree_scene = preload("res://Farming/tree.tscn")
@onready var invisible_trunk_collider_scene = preload("res://Farming/tree_trunk_collider.tscn")
#var tree_dimensions:Vector2

var sprite_trunk_offset

func _draw():
	sprite_trunk_offset = Vector2(-1*tree_trunk_texture.get_width()/2, -1*tree_trunk_texture.get_height()) + Vector2(0,10)
	_draw_tree_grid(Vector2(-1400, -800), Vector2(3400, 2800), 20, 40, 0.4,
					Vector2(-500, -300), Vector2(1100, 800), 80)
	
	

func _draw_tree_grid(upper_left_position:Vector2, grid_size:Vector2, cell_width, cell_height, max_displacement_ratio, 
					 clearing_upper_left_position=Vector2.ZERO, clearing_lower_right_position=Vector2.ZERO, real_tree_border_width=0):
	var current_row:int
	var current_column:int
	var current_row_y_pos = 0
	var current_col_x_pos = 0
	var max_x_displacement = cell_width*max_displacement_ratio
	var max_y_displacement = cell_height*max_displacement_ratio
	
	var draw_positions = []
	
	while (current_row_y_pos < grid_size.y):
		current_column = 0
		current_col_x_pos = current_column*cell_width
		
		while (current_col_x_pos < grid_size.x):
			var displacement = Vector2(randf_range(-max_x_displacement, max_x_displacement), randf_range(-max_y_displacement, max_y_displacement))
			var spawn_position = upper_left_position + Vector2(current_col_x_pos, current_row_y_pos) + displacement
			
			#If any of these clauses are true, then this position is outside of the clearing
			if (spawn_position.x < clearing_upper_left_position.x
				or spawn_position.x > clearing_lower_right_position.x
				or spawn_position.y < clearing_upper_left_position.y
				or spawn_position.y > clearing_lower_right_position.y):
				draw_positions.push_back(spawn_position + sprite_trunk_offset)
			
			current_column += 1
			current_col_x_pos = current_column*cell_width
		
		current_row += 1
		current_row_y_pos = current_row*cell_height
	
	draw_positions.sort_custom(sort_vectors_by_y_ascending)
	
	for pos in draw_positions:		
		#If all of these clauses are true, then this position is less than real_tree_border_width pixels away from the edge of the clearing
		#Let's spawn an invisible static collider where the trunk is
		var spawn_position = pos - sprite_trunk_offset
		if (spawn_position.x > (clearing_upper_left_position.x-real_tree_border_width)
			and spawn_position.x < (clearing_lower_right_position.x+real_tree_border_width)
			and spawn_position.y > (clearing_upper_left_position.y-real_tree_border_width)
			and spawn_position.y < (clearing_lower_right_position.y+real_tree_border_width)):
			instantiate_tree_trunk_collider(pos - sprite_trunk_offset)
	
	
	'''
	for pos in draw_positions:
		instantiate_real_tree(pos)
	'''
	
	$ShadowLayer.draw_at_positions(draw_positions)
	$TrunkLayer.draw_at_positions(draw_positions)
	$FoliageLayer.draw_at_positions(draw_positions)
	
	'''
	for pos in draw_positions:
		draw_texture(tree_shadow_texture, pos)
	for pos in draw_positions:
		draw_texture(tree_trunk_texture, pos)
		draw_texture(tree_foliage_texture, pos)
		#draw_texture_rect_region(tree_texture, Rect2(pos, tree_region_rect.size), tree_region_rect)
	'''

func draw_fake_tree(pos):
	draw_texture(tree_trunk_texture, pos)
	draw_texture(tree_foliage_texture, pos)

func instantiate_tree_trunk_collider(pos):
	var tree = invisible_trunk_collider_scene.instantiate()
	tree.position = pos
	add_child(tree)

func sort_vectors_by_y_ascending(a, b):
	return (a.y < b.y)
