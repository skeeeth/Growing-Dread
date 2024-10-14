extends Node2D


@export var texture_to_draw:Texture2D

var draw_positions = []

func draw_at_positions(new_positions):
	draw_positions = new_positions
	queue_redraw()

func _draw():
	for pos in draw_positions:
		draw_texture(texture_to_draw, pos)
