extends Node2D
class_name Enemy

signal died(id)

@onready var hurtbox:Hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready():
	hurtbox.died.connect(death)
	pass # Replace with function body.


func death():
	died.emit(self)
	queue_free()
