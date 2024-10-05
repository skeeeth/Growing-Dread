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

var target_wandering_velocity:Vector2
var facing_direction:String = "right"
var recently_collided:bool = false


func _ready():
	state = SheepState.Idle
	$WanderIdleEatTimer.start(min_idle_time)


func _on_wander_idle_eat_timer_timeout():
	if (state != SheepState.Idle): #If eating or wandering, always transition to idling
		start_idling()
	elif (randf() > 0.7): #If idling, 30% chance of eating
		state = SheepState.Eating
		$WanderIdleEatTimer.start(randi_range(min_eating_cycles, max_eating_cycles) * $SheepSprite/AnimationPlayer.get_animation("eating_" + facing_direction).length)
		
		linear_velocity = Vector2.ZERO
		
		$SheepSprite/AnimationPlayer.play("eating_" + facing_direction)
	else:
		state = SheepState.Wandering
		$WanderIdleEatTimer.wait_time = randf_range(min_wandering_time, max_wandering_time)
		
		target_wandering_velocity = pick_wandering_direction() * wandering_speed
		change_facing(target_wandering_velocity)
		
		$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)


func start_idling():
	state = SheepState.Idle
	$WanderIdleEatTimer.wait_time = randf_range(min_idle_time, max_idle_time)
	
	linear_velocity = Vector2.ZERO
	
	$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)
	$SheepSprite/AnimationPlayer.stop()


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


func pick_wandering_direction():
	if (recently_collided): #When the collision happened, the sheep bounced away from the colliding object and we saved that new velocity as target_wandering_velocity
							#Let's keep going in that direction to avoid bumping into that obstacle again 
		recently_collided = false
		return target_wandering_velocity.normalized()
	else:
		return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()


func _physics_process(delta):
	if (state == SheepState.Wandering):
		if ((linear_velocity-target_wandering_velocity).length() > 0.1):
			apply_force(target_wandering_velocity.normalized() * wandering_acceleration * delta)


func _on_body_entered(body):
	if (state == SheepState.Wandering):
		#This logic expects the Rigidbody to be bouncy so that the sheep starts walking away from the obstacle
		#However, it looks unnatural if the sheep walks into a wall and immediately starts going in the other direction, so let's save the new direction and switch to idling
		recently_collided = true
		target_wandering_velocity = linear_velocity.normalized() * wandering_speed
		start_idling()
