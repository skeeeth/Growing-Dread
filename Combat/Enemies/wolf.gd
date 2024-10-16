class_name Wolf
extends CharacterBody2D

signal died(id)
# todo: add sneaking state :todo
enum WolfState { Chilling, Chasing, Biting, Dragging, Dead, }

var state:int = WolfState.Chilling:
	set(a_state):
		match a_state:
			WolfState.Chilling:
				state = a_state
				$coyote_image.animation = "idle"
			WolfState.Chasing:
				state = a_state
				$coyote_image.animation = "run"
			WolfState.Biting:
				state = a_state
				$FarmableTile/CropDisplay.animation = "attack"
			WolfState.Dragging:
				state = a_state
				$FarmableTile/CropDisplay.animation = "uhhhhhh...."
			WolfState.Dead:
				state = a_state
				$FarmableTile/CropDisplay.animation = "uhhhhhh...."
			_:
				print("Warning : farmable_tile.gd::_set_state(...)! Undefined farmable_tile state!")
	get:
		return state
		

@export var bite_distance:float
@export var chasing_speed:float
@export var dragging_speed:float

@export var target_sheep:RigidBody2D

var bite_position_adjustment = Vector2(-20.0, 3.0)

var dragging_initial_sheep_displacement

@onready var hurtbox:Hurtbox = $Hurtbox


func assign_target_sheep(new_target_sheep):
	target_sheep = new_target_sheep
	_start_chasing()


func die():
	died.emit(self)
	target_sheep.on_immobilizer_died()
	queue_free()


func _ready():
	hurtbox.died.connect(die)
	if (target_sheep != null):
		_start_chasing()
	else:
		state = WolfState.Chilling
	$coyote_image.play()


func _start_chasing():
	state = WolfState.Chasing
	#$Sprite2D/AnimationPlayer.play("run_right")


func _start_biting():
	state = WolfState.Biting
	
	#$Sprite2D/AnimationPlayer.play("bite_right")
	
	#Wait until we're 70% through the bite animation, which is roughly where the bite itself happens
	#$BitingTimer.start($Sprite2D/AnimationPlayer.get_animation("bite_right").length*0.7)
	await $BitingTimer.timeout
	
	if (state == WolfState.Biting):
		target_sheep.become_immobilized(self)
		state = WolfState.Dragging
		velocity = Vector2.LEFT * dragging_speed
		#$Sprite2D/AnimationPlayer.play("drag_right")
		dragging_initial_sheep_displacement = target_sheep.global_position - global_position


func _physics_process(delta):
	if (state == WolfState.Chasing):
		var target_sheep_displacement = (target_sheep.global_position + bite_position_adjustment) - global_position
		if ((global_position.y > target_sheep.global_position.y) and target_sheep_displacement.length() < bite_distance):
			velocity = Vector2.ZERO
			_start_biting()
		else:
			velocity = target_sheep_displacement.normalized() * chasing_speed
	
	move_and_slide()
	
	if (state == WolfState.Dragging):
		target_sheep.global_position = global_position + dragging_initial_sheep_displacement #Bring the sheep along by keeping the same relative position

