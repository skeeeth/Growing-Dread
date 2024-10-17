extends Node

@export var melt_filter:ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _on_melt_timeout():
	var melt_tween = create_tween()
	var rssp = func reversed_set_shader_parameter(val,uniform): #lambda
		melt_filter.material.set_shader_parameter(uniform,val)
		
	melt_tween.tween_method(rssp.bind("melt_p"),0.0,0.15,1.5)
	melt_tween.tween_method(rssp.bind("melt_p"),0.1,-0.03,0.03)
	melt_tween.tween_method(rssp.bind("melt_p"),-0.03,0.0,0.01)
	pass # Replace with function body.
