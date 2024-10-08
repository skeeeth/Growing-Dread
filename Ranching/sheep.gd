extends RigidBody2D

enum SheepState {
	Idle,
	Wandering,
	Eating,
	Sleeping,
	Fleeing,
	Immobilized,
	Dead,
}

var state:SheepState;

@export var min_idle_time:float 
@export var max_idle_time:float
@export var min_wandering_time:float 
@export var max_wandering_time:float
@export var min_eating_cycles:int
@export var max_eating_cycles:int

@export var movement_acceleration:float
@export var wandering_speed:float
@export var fleeing_speed:float

var desired_movement_velocity:Vector2


var facing_direction:String = "right"
var recently_collided:bool = false

var nearby_enemies = {}

func become_immobilized(immobilizer:Wolf):
	state = SheepState.Immobilized
	$WanderIdleEatTimer.stop()
	linear_velocity = Vector2.ZERO
	$SheepSprite/AnimationPlayer.play("immobilized")
	#immobilizer.died.connect(_on_immobilizer_died) #Wanted to use signals but couldn't get it to work


func on_immobilizer_died():
	if (state == SheepState.Immobilized):
		$WanderIdleEatTimer.start(max_idle_time)
	

func die():
	state = SheepState.Dead
	$WanderIdleEatTimer.stop()

func _ready():
	state = SheepState.Idle
	$WanderIdleEatTimer.start(min_idle_time)


func _on_wander_idle_eat_timer_timeout():
	
	if (state != SheepState.Idle): #If eating or wandering, always transition to idling
		_start_idling()
	elif (randf() > 0.7): #If idling, 30% chance of eating
		state = SheepState.Eating
		$WanderIdleEatTimer.start(randi_range(min_eating_cycles, max_eating_cycles) * $SheepSprite/AnimationPlayer.get_animation("eating_" + facing_direction).length)
		
		linear_velocity = Vector2.ZERO
		
		$SheepSprite/AnimationPlayer.play("eating_" + facing_direction)
	else:
		desired_movement_velocity = _pick_wandering_direction() * wandering_speed
		_start_wandering()


func _start_idling():
	#print("Started idling")
	linear_velocity = Vector2.ZERO
	state = SheepState.Idle
	$WanderIdleEatTimer.start(randf_range(min_idle_time, max_idle_time))
	_stand_still()


#Note: this assumes you've already assigned desired_movement_velocity
func _start_wandering():
	#print("Started wandering")
	state = SheepState.Wandering
	$WanderIdleEatTimer.start(randf_range(min_wandering_time, max_wandering_time))
	_change_facing(desired_movement_velocity)
	$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)


func _stand_still():
	linear_velocity = Vector2.ZERO
	$SheepSprite/AnimationPlayer.play("walk_" + facing_direction)
	$SheepSprite/AnimationPlayer.stop()


func _change_facing(new_velocity:Vector2):
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


func _pick_wandering_direction():
	if (recently_collided): #When the collision happened, the sheep bounced away from the colliding object and we saved that new velocity as desired_movement_velocity
							#Let's keep going in that direction to avoid bumping into that obstacle again 
		recently_collided = false
		return desired_movement_velocity.normalized()
	else:
		return Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()


func _physics_process(delta):
	#print(str(state))
	if (state == SheepState.Fleeing):
		#print("Let's figure out where to run")
		var closest_enemy_displacement = null
		for enemy in nearby_enemies:
			var this_enemy_displacement = enemy.global_position - global_position
			if (closest_enemy_displacement == null
				or closest_enemy_displacement.length() > this_enemy_displacement.length()):
				closest_enemy_displacement = this_enemy_displacement
		
		if (closest_enemy_displacement != null):
			#print("I'm going to run this way: " + str(closest_enemy_displacement.normalized().rotated(PI)) + " at this speed: " + str(fleeing_speed))
			var old_facing_direction = facing_direction
			desired_movement_velocity = closest_enemy_displacement.normalized().rotated(PI) * fleeing_speed
			_change_facing(desired_movement_velocity)
			if (old_facing_direction != facing_direction):
				$SheepSprite/AnimationPlayer.play("walk_" + facing_direction, -1, 2.0)
				
			
		else:
			pass#print("Fleeing, but couldn't figure out where to run")
	
	if (state == SheepState.Fleeing or state == SheepState.Wandering):
		if ((linear_velocity-desired_movement_velocity).length() > 0.1):
			apply_force(desired_movement_velocity.normalized() * movement_acceleration * delta)


func _on_body_entered(body):
	if (state == SheepState.Wandering):
		#This logic expects the Rigidbody to be bouncy so that the sheep starts walking away from the obstacle
		#However, it looks unnatural if the sheep walks into a wall and immediately starts going in the other direction, so let's save the new direction and switch to idling
		recently_collided = true
		desired_movement_velocity = linear_velocity.normalized() * wandering_speed
		_start_idling()
	


func _on_threat_detector_body_entered(body):
	if (body.is_in_group("enemies")):
		
		if (nearby_enemies.is_empty()):
			state = SheepState.Fleeing
			$WanderIdleEatTimer.stop()
			print("Run for your life!!!")
			desired_movement_velocity = (global_position - body.global_position).normalized() * fleeing_speed
			_change_facing(desired_movement_velocity)
			$SheepSprite/AnimationPlayer.play("walk_" + facing_direction, -1, 2.0)
		
		nearby_enemies[body] = null


func _on_threat_detector_body_exited(body):
	if (body.is_in_group("enemies")):
		nearby_enemies.erase(body)
		
		if (nearby_enemies.is_empty() and state == SheepState.Fleeing): 
			#If there are no more nearby enemies, slow down to wandering speed, but keep moving in the same direction
			#It would look strange if sheep go immediately from fleeing to idling or sleeping
			
			desired_movement_velocity = desired_movement_velocity.normalized() * wandering_speed
			_start_wandering()
