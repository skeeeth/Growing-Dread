## 
##
extends Area2D
class_name Hurtbox

signal died #parent should connect death behavior to this
signal hit(remaining_health)
signal took_damage
@export var health:float
@export var visual:Sprite2D

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func take_damage(amount):
	health -= amount
	took_damage.emit()
	
	#hitflash
	#tween_method can only interpolate on on the first argument of a callable, so I have to make a lambda
	# just to swap the arg order
	var flash = create_tween()
	var rssp = func reversed_set_shader_parameter(val,uniform): #lambda
		visual.material.set_shader_parameter(uniform,val)
	
	flash.tween_method(rssp.bind("intensity"),1.0,0.0,0.1)
	flash.tween_method(rssp.bind("intensity"),0.0,1.0,0.1)

	if health <= 0:
		died.emit()
