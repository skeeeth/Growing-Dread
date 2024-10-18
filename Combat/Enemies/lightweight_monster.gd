extends Area2D

enum MonsterState {
	Chilling,
	Chasing,
	AttackingPlayer,
	Wandering,
}

signal stopped_chasing_player
signal died

@export var chasing_speed:float

var state
var target_sheep
var player

@export var attack_distance:float

var minimum_player_chase_duration = 10
var maximum_player_chase_duration = 20
var minimum_wander_duration = 2
var maximum_wander_duration = 30

var torch_bravery

#@export var movement_acceleration:float

var desired_movement_velocity:Vector2

func die():
	died.emit(self)
	queue_free()


func start_chasing_player():
	state = MonsterState.AttackingPlayer
	$WanderTimer.stop()


func on_wander_timer_timeout():
	start_wandering()

func start_wandering():
	state = MonsterState.Wandering
	change_wander_direction()
		
func change_wander_direction():
	if (global_position.length() > chasing_speed * 8):
		desired_movement_velocity = -global_position.normalized()
	else:
		desired_movement_velocity = Vector2.from_angle(randf() * TAU).normalized()
	$WanderTimer.start(2)

func on_touched_light_source(light_source):
	if (state == MonsterState.AttackingPlayer):
		stopped_chasing_player.emit(get_instance_id())
		start_wandering()
		
	desired_movement_velocity = (global_position - light_source.global_position).normalized()

func start_chasing_sheep():
	var sheep = get_tree().get_nodes_in_group("sheep")

	if (len(sheep) > 0):
		target_sheep = sheep[randi_range(0, len(sheep)-1)]
		state = MonsterState.Chasing
		$Sprite2D/AnimationPlayer.play("walk_left", -1, 3.0)
	else:
		start_wandering()

func _ready():
	$Sprite2D/AnimationPlayer.play("walk_left", -1, 3.0)
	start_wandering()
	
	torch_bravery = randi_range(-50, 0)

func _infest_sheep():
	target_sheep.become_infested()
	queue_free()
	
func _physics_process(delta):
	var velocity = Vector2.ZERO
	
	if (state == MonsterState.Chasing):
		var target_sheep_displacement = (target_sheep.global_position) - global_position
		if (target_sheep_displacement.length() < attack_distance):
			#velocity = Vector2.ZERO
			_infest_sheep()
		else:
			velocity = target_sheep_displacement.normalized() * chasing_speed
	elif (player != null):
		var player_displacement = player.global_position - global_position
		var torch_nudge_strength = 0
		
		if (player.torch_radius > 0):
			var modified_player_displacement_length = (player_displacement.length()+torch_bravery)
			
			if (modified_player_displacement_length < player.torch_radius):
				on_touched_light_source(player)
				torch_nudge_strength = 1
			elif (modified_player_displacement_length < 2*player.torch_radius):
				var distance_from_torch_area = modified_player_displacement_length - player.torch_radius
				var fake_distance = distance_from_torch_area - 2
				var normalized_distance = clampf(fake_distance/player.torch_radius, 0, 1)
				torch_nudge_strength = 1 - normalized_distance
		elif (player_displacement.length() < attack_distance):
			player.take_damage(10)
			queue_free()
		
		if (state == MonsterState.AttackingPlayer):
			velocity = player_displacement.normalized() * chasing_speed# (player.torch_radius+1) / player_displacement.length()))
		elif (state == MonsterState.Wandering):
			velocity = desired_movement_velocity * chasing_speed
		
		if (torch_nudge_strength > 0):
			velocity -= player_displacement.normalized() * torch_nudge_strength * chasing_speed
	
	$Sprite2D.flip_h = velocity.x >= 0
	position += velocity * delta
