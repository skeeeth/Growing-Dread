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
	desired_movement_velocity = Vector2.from_angle(randf() * TAU).normalized()
	$WanderTimer.start(2)


func on_touched_light_source(light_source):
	if (state == MonsterState.AttackingPlayer):
		stopped_chasing_player.emit(get_instance_id())
		
	start_wandering()
	desired_movement_velocity = (global_position - light_source.global_position).normalized()

func _ready():
	var sheep = get_tree().get_nodes_in_group("sheep")

	if (len(sheep) > 0):
		target_sheep = sheep[randi_range(0, len(sheep)-1)]
		state = MonsterState.Chasing
		$Sprite2D/AnimationPlayer.play("walk_left", -1, 3.0)
	else:
		start_wandering()
	
	$Hurtbox.died.connect(die)

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
			desired_movement_velocity = target_sheep_displacement.normalized() * chasing_speed
	elif (state == MonsterState.AttackingPlayer):
		var player_displacement = player.global_position - global_position
		
		velocity = player_displacement.normalized() * chasing_speed
		#if (player_displacement.length() < player.torch_radius):
		#	var close_to_player_ratio = player.torch_radius / player_displacement.length()
		#	desired_movement_velocity *= close_to_player_ratio
			
		#var playback_speed = clampf(velocity.length() * 0.04, 0.2, 0.6)
		
		#$Sprite2D/AnimationPlayer.speed_scale = playback_speed
		#$Sprite2D.flip_h = velocity.x >= 0
		
	elif (state == MonsterState.Wandering):
		velocity = desired_movement_velocity * chasing_speed
	
	position += velocity * delta
