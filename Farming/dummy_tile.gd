extends FarmTile


# Called when the node enters the scene tree for the first time.
func _ready():
	#POSSIBLY THE WORST HACK OF ALL TIME
	var door_position = Vector2(400,0) #probably overreacting
	if (global_position - door_position).length() < 128:
		queue_free()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

#func interact(_type,crop):
	#return
