class_name Infested_Wolf
extends CharacterBody2D

signal died(id)

enum InfestedWolfState {
	Chilling,
	Approaching,
	Exploding,
}

var state:InfestedWolfState

#@export var bite_distance:float
@export var approaching_speed:float
var current_speed:float

#@export var dragging_speed:float

#@export var target_sheep:RigidBody2D
@export var target_position:Vector2


@export var monster_spawn_delay:float
@onready var monster_spawner_scene = preload("res://Combat/monster_spawner.tscn")

#var bite_position_adjustment = Vector2(-20.0, 3.0)

#var dragging_initial_sheep_displacement

@onready var hurtbox:Hurtbox = $Hurtbox
@onready var hurtbox_collision_shape:CollisionShape2D = $Hurtbox/CollisionShape2D


func die():
	died.emit(self)
	
	state = InfestedWolfState.Exploding
	hurtbox_collision_shape.disabled = true
	
	
	$Sprite2D/AnimationPlayer.play("wolf_explode")
	
	await get_tree().create_timer(monster_spawn_delay).timeout
	var monster_spawner = monster_spawner_scene.instantiate()
	monster_spawner.global_position = global_position
	monster_spawner.init(40, 40, 2, 5)
	get_tree().current_scene.add_child(monster_spawner)
	
	await get_tree().create_timer(0.5).timeout
	$Sprite2D/AnimationPlayer.stop(true)
	
	$CollisionShape2D.disabled = true

func on_took_damage():
	current_speed *= 0.8
	$Sprite2D/AnimationPlayer.play("drag_right", -1, -1*(current_speed/approaching_speed), true)

func _ready():
	hurtbox.died.connect(die)
	hurtbox.took_damage.connect(on_took_damage)
	current_speed = approaching_speed
	state = InfestedWolfState.Approaching
	#$Sprite2D/AnimationPlayer.play("run_right")
	$Sprite2D/AnimationPlayer.play("drag_right", -1, -1, true)


func _physics_process(delta):
	if (state == InfestedWolfState.Approaching):
		var target_position_displacement = target_position - global_position
		if (target_position_displacement.length() < 5):
			velocity = Vector2.ZERO
			die()
		else:
			velocity = target_position_displacement.normalized() * current_speed
			$Sprite2D.flip_h = velocity.x < 0
	
		move_and_slide()
