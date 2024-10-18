class_name Wolf
extends CharacterBody2D

signal died(id)

enum WolfState {
	Chilling,
	#Sneaking, #Would be cool to add a sneaking state where it walks towards the target_sheep. Switch from sneaking to chasing once the sheep starts to flee
	Chasing,
	Biting,
	Dragging,
	Fleeing,
	Dead,
}

var state:WolfState

@export var bite_distance:float
@export var chasing_speed:float
@export var dragging_speed:float

@export var target_sheep:RigidBody2D

var bite_position_adjustment = Vector2(-20.0, 10.0)

var dragging_initial_sheep_displacement

@onready var hurtbox:Hurtbox = $Hurtbox
@export var edge:float

func assign_target_sheep(new_target_sheep):
	target_sheep = new_target_sheep
	_start_chasing()


func die():
	died.emit(self)
	target_sheep.on_immobilizer_died()
	queue_free()


func on_escape():
	if (state == WolfState.Dragging):
		target_sheep.queue_free()
		queue_free()
	elif (state == WolfState.Fleeing):
		queue_free()

	
func _ready():
	hurtbox.died.connect(die)
	if (target_sheep != null):
		_start_chasing()
	else:
		state = WolfState.Chilling


func _start_chasing():
	state = WolfState.Chasing
	$Sprite2D/AnimationPlayer.play("run_right")


func _start_biting():
	state = WolfState.Biting
	
	$Sprite2D/AnimationPlayer.play("bite_right")
	
	#Wait until we're 70% through the bite animation, which is roughly where the bite itself happens
	$BitingTimer.start($Sprite2D/AnimationPlayer.get_animation("bite_right").length*0.7)
	await $BitingTimer.timeout
	
	if (state == WolfState.Biting):
		target_sheep.become_immobilized(self)
		state = WolfState.Dragging
		$Sprite2D.flip_h = false
		velocity = Vector2.LEFT * dragging_speed
		$Sprite2D/AnimationPlayer.play("drag_right")
		dragging_initial_sheep_displacement = target_sheep.global_position - global_position


func _physics_process(delta):
	if (state == WolfState.Chasing):
		var target_sheep_displacement = (target_sheep.global_position + bite_position_adjustment) - global_position
		if ((global_position.y > target_sheep.global_position.y) and target_sheep_displacement.length() < bite_distance):
			velocity = Vector2.ZERO
			_start_biting()
		else:
			velocity = target_sheep_displacement.normalized() * chasing_speed
			$Sprite2D.flip_h = velocity.x < 0
	
	move_and_slide()
	
	if (state == WolfState.Dragging):
		target_sheep.global_position = global_position + dragging_initial_sheep_displacement #Bring the sheep along by keeping the same relative position
		if position.x < edge:
			queue_free()

func _exit_tree():
	died.emit(self)
