extends Node2D

var previous_position:Vector2
var accumulated_distance:float
@export var cadence:float
@export var character:CharacterBody2D
@onready var wood = $Wood
@onready var dirt = $Dirt
var home:Home
# Called when the node enters the scene tree for the first time.
func _ready():
	cadence = cadence * cadence
	previous_position = global_position
	
	home = get_tree().get_first_node_in_group("Home")
	#i like hate this way of getting references but it probably
	# is the best here


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var change = (character.global_position - previous_position)
	accumulated_distance += change.length_squared()
	if accumulated_distance > cadence:
		accumulated_distance -= cadence
		if home.is_inside:
			wood.play()
		else:
			dirt.play()
	previous_position = character.global_position
	pass
