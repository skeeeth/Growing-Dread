extends Node2D
class_name Enemy

@onready var hurtbox:Hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox.died.connect(death)
	pass # Replace with function body.


func death():
	queue_free()
