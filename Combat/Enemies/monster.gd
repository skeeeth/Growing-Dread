extends CharacterBody2D

enum MonsterState {
	Chilling,
	Chasing,
}

@export var chasing_speed:float

var state
var target_sheep

@export var attack_distance:float


func die():
	queue_free()

func _ready():
	var sheep = get_tree().get_nodes_in_group("sheep")

	if (len(sheep) > 0):
		target_sheep = sheep[randi_range(0, len(sheep)-1)]
		state = MonsterState.Chasing
		$Sprite2D/AnimationPlayer.play("walk_left", -1, 3.0)
	
	$Hurtbox.died.connect(die)

func _infest_sheep():
	target_sheep.become_infested()
	queue_free()
	
func _physics_process(delta):
	if (state == MonsterState.Chasing):
		var target_sheep_displacement = (target_sheep.global_position) - global_position
		if (target_sheep_displacement.length() < attack_distance):
			velocity = Vector2.ZERO
			_infest_sheep()
		else:
			velocity = target_sheep_displacement.normalized() * chasing_speed
			$Sprite2D.flip_h = (velocity.x >= 0)
	
	move_and_slide()
