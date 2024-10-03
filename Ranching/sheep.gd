extends RigidBody2D

enum SheepState {
	Idle,
	Wandering,
	Eating,
	Sleeping,
	Dead,
}

var state:SheepState;

@export var min_idle_time:float 
@export var max_idle_time:float
@export var min_wandering_time:float 
@export var max_wandering_time:float
@export var min_eating_cycles:int
@export var max_eating_cycles:int

@export var wandering_acceleration:float
@export var wandering_speed:float

var target_velocity:Vector2
var facing_direction:String = "right"

func _ready():
	state = SheepState.Idle
	$WanderIdleEatTimer.start(max_idle_time)

func _on_wander_idle_eat_timer_timeout():
	if (state != SheepState.Idle): #If eating or wandering, always transition to idling
		state = SheepState.Idle
		$WanderIdleEatTimer.wait_time = randf_range(min_idle_time, max_idle_time)
		
		linear_velocity = Vector2.ZERO
		
		$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)
		$SheepSprite/AnimationPlayer.stop()
	elif (randf() > 0.7): #If idling, 30% chance of eating
		state = SheepState.Eating
		$WanderIdleEatTimer.start(randi_range(min_eating_cycles, max_eating_cycles) * $SheepSprite/AnimationPlayer.get_animation("eating_" + facing_direction).length)
		
		linear_velocity = Vector2.ZERO
		
		$SheepSprite/AnimationPlayer.play("eating_" + facing_direction)
	else:
		state = SheepState.Wandering
		$WanderIdleEatTimer.wait_time = randf_range(min_wandering_time, max_wandering_time)
		
		target_velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * wandering_speed
		change_facing(target_velocity)
		
		$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)


func change_facing(new_velocity:Vector2):
	if (abs(new_velocity.x) > abs(new_velocity.y)):
		if (new_velocity.x > 0):
			facing_direction = "right"
		else:
			facing_direction = "left"
	else:
		if (new_velocity.y > 0):
			facing_direction = "down"
		else:
			facing_direction = "up"

func _physics_process(delta):
	if (state == SheepState.Wandering):
		if (linear_velocity.length() < target_velocity.length()):		
			apply_force(target_velocity.normalized() * wandering_acceleration * delta)
