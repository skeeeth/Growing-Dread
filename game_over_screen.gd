extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("lmb"):
		get_tree().change_scene_to_file("res://title_scene.tscn")
	pass # Replace with function body.
