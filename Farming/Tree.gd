extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$farmer_image.animation = "Look_Straight"
	$farmer_image.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
