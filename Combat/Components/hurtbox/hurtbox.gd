## 
##
extends Area2D
class_name Hurtbox

signal died #parent should connect death behavior to this
@export var health:float

## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func take_damage(amount):
	health -= amount
	if health <= 0:
		died.emit()
