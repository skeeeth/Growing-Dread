extends Node
class_name NextDayManager

@onready var next_day_card = $NextDayCard
@onready var card_text = $NextDayCard/Label

@onready var moonlight = $"../Moonlight"
@onready var darkness = $"../Darkness"
@onready var spawn_point = $"../SpawnPoint"
@onready var crt_filter = $"../Camera2D/ScreenSpace/CRT_Filter"
@onready var day_layer = $"../Camera2D/ScreenSpace/Day"
var timer = 0.0
const SHOW_CARD_DURATION = 3.0
@export var cam:CRT_Cam
@export var player:CharacterBody2D
var farm_character = preload("res://Farming/Character/Player/Player_F.tscn")
var night_character = preload("res://Combat/Player/Player_C.tscn")
@onready var static_sound = $"../Static"
@onready var ui = $"../UI"

@export var enemy_instancer:EnemyInstancer
@export var monster_spawner:MonsterSpawner

@export var moonlight_energy:float = 0.6
@export var darkness_energy:float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	#Farming.day_progressed.connect(next_day)
	#Farming.night_fallen.connect(go_to_night)
	Farming.woke_up.connect(wake_up_player)
	Farming.fell_asleep.connect(on_fell_asleep)
	#next_day_card.reparent(cam,false)
	#next_day_card.position = cam.crt_overlay.position
	wake_up_player()



func on_fell_asleep():
	if (Farming.is_nighttime):
		next_day()
	else: #Going to bed at the end of the day - check if it's time for a night event
		if (Farming.day == 0):
			go_to_night()
			Farming.event_active = true
			enemy_instancer.spawn_regular_wolves(5)
		elif (Farming.day == 1):
			go_to_night()
			enemy_instancer.spawn_infested_wolf()
		elif (Farming.day == 2):
			go_to_night()
			monster_spawner.init(1200, 0, 0.1, 1000, player)
			player.torch_radius_decay_rate = 3
		else:
			next_day()

func wake_up_player():
	player.is_sleeping = false

func next_day():
	Farming.next_day()
	card_text.text = "Day " + str(Farming.day)
	day_layer.visible = true
	var fade_out = create_tween()
	fade_out.set_parallel()
	
	fade_out.tween_property(crt_filter,"modulate:a",0.0,0.5) 
	#i guess alterering modulate for a screen_reading shader doesnt actually cause a fade
	#TODO: I'll have to change this to instead alter the uniforms to get the desired effect
	
	fade_out.tween_property(moonlight,"energy",0.0,2.0)
	fade_out.tween_property(static_sound,"volume_db",-80,2.0)
	fade_out.tween_property(darkness,"energy",0.0,2.0)
	_replace_player(farm_character)
	#_show_card()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer > 0):
		timer -= delta
		if(timer <= 0):
			timer = 0
			next_day_card.visible = false


func go_to_night():
	Farming.go_to_night()
	
	card_text.text = "Night " + str(Farming.day)
	day_layer.visible = false
	$Howl.play()
	var fade_in = create_tween()
	fade_in.set_parallel()
	fade_in.tween_property(crt_filter,"modulate:a",1.0,0.5) #TODO: fix this (see next_day())
	fade_in.tween_property(static_sound,"volume_db",-25.0,3.3)
	fade_in.tween_property(moonlight,"energy",moonlight_energy,3.3)
	fade_in.tween_property(darkness,"energy",darkness_energy,3.3)
	##TODO should probalby have some kinda sound here
	_replace_player(night_character)
	
	#_show_card()
	pass

func _show_card():
	next_day_card.visible = true
	timer = SHOW_CARD_DURATION
	
func _replace_player(new_character:PackedScene): #Swaps Player
	var previous_player = player
	var new_player:CharacterBody2D = new_character.instantiate()
	#new_player.on_sleeping_screen_cover_finished
	new_player.global_position = player.global_position #spawn_point.global_position
	player = new_player
	cam.tracked_object = player
	previous_player.queue_free() ##TODO: probably some kind of walk into house animation
	add_sibling(new_player) ##TODO: should also have a walk out of house animation
